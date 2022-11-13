open Netlist_ast
open Graph

exception Combinational_cycle

let is_var ag = match ag with
	|Avar id -> id
	|Aconst _ -> ""

let rec arg_to_list lst_arg = match lst_arg with
	|[] -> []
	|t::q -> begin match (is_var t) with
						|"" -> arg_to_list q
						|id -> id::(arg_to_list q)
						end

(* Add the future expression to manage *)
let eq_to_add exp = match exp with
	|Earg(Aconst _) | Ereg _ | Eram _-> true
	|_ -> false

let read_exp eq = 
	let (_, exp) = eq in
	match exp with
		| Earg a -> arg_to_list [a]
		| Ereg _ -> []
    | Enot a -> arg_to_list [a]
    | Ebinop (_, a, b) -> arg_to_list [a; b]
    | Emux (_, a, b) -> arg_to_list [a; b]
    | Erom (_, _, a) -> arg_to_list [a]
    | Eram (_, _, a, _, _, _) -> arg_to_list [a] 
    | Econcat (a, b) -> arg_to_list [a; b]
    | Eslice (_, _, a) -> arg_to_list [a]
    | Eselect (_, a) -> arg_to_list [a]


let rec add_var g = function
	|[] -> g
	|v::q -> add_node g v; add_var g q


let schedule p = 
	let g = mk_graph () in 
	let (k, _) = List.split (Env.bindings p.p_vars) in
	let gr = add_var g k in
	let rec add_arg g id = function
		|[] -> ()
		|a::q -> add_edge g id a; add_arg g id q
	in 
	let rec parc_eqs g = function
		|[] -> g
		|eq::t -> let (id, _) = eq in add_arg g id (read_exp eq) ; parc_eqs g t
	in 
	let graph = parc_eqs gr p.p_eqs in
	let topo_lst = try topological graph 
		with Cycle -> raise Combinational_cycle
	in 
	let rec find_exp var lst_exp lst_eq = match lst_exp with
		|[] -> lst_eq
		|t::q when ((not (List.mem t lst_eq)) && (List.mem var (read_exp t))) -> find_exp var q (t::lst_eq)
		|(id, exp)::q when ((eq_to_add exp) && (not (List.mem (id, exp) lst_eq))) -> find_exp var q ((id,exp)::lst_eq)
		|_::q -> find_exp var q lst_eq
	in
	let rec make_eq_lst topol eq_lst = match topol with
		|[] -> eq_lst
		|t::q when List.mem t (p.p_outputs) -> make_eq_lst q eq_lst
		|t::q -> make_eq_lst q (find_exp t p.p_eqs eq_lst)
	in
	{p_eqs = (make_eq_lst (topo_lst) []) ; p_inputs = p.p_inputs ; p_outputs = p.p_outputs ; p_vars = p.p_vars} 


	(*
	let rec find_exp var lst_exp lst_eq = match lst_exp with
		|[] -> lst_eq
		|t::q when ((not (List.mem t lst_eq)) && (List.mem var (read_exp t))) -> find_exp var q (t::lst_eq)
		|t::q -> find_exp var q lst_eq
	in 
	*)
