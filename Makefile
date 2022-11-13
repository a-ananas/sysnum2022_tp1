file = fulladder
n = 
list = "clock_div cm2 fulladder nadder ram"
print = 


all: netlist_simulator.byte
ifndef n
	dune exec ./netlist_simulator.exe test/$(file).net
else
	dune exec -- ./netlist_simulator.exe -n $(n)  test/$(file).net
endif

sched: scheduler_test.byte
ifdef n
	dune exec -- ./scheduler_test.exe -n $(n)  test/$(file).net
else ifndef print
	dune exec ./scheduler_test.exe test/$(file).net
else
	dune exec -- ./scheduler_test.exe -print test/$(file).net
	cat test/$(file)_sch.net
endif

graph: graph.byte
	dune exec ./graph_test.exe

netlist_simulator.byte: netlist_simulator.ml
	dune build netlist_simulator.exe

graph.byte: graph.ml
	dune build netlist_simulator.exe

scheduler_test.byte: scheduler.ml graph.ml
	dune build scheduler_test.exe

list: 
	@echo "liste des valeurs possibles pour \`file\` : "$(list)

help:
	@echo "aide pour le projet de simulateur\n\n\
		help : affiche cette aide\n\
		défaut : exécute netlist_simulator sur fulladder\n\
			variables :\n\
				file : fichier à exécuter\n\
				n : nombres de cycles\n\
		sched : exécute le test de scheduler sur fulladder\n\
			variables :\n\
				file : fichier à exécuter\n\
				n : nombres de cycles\n\
				print : option print\n\
		graph : exécute les tests du tri topologique\n\
		list : affiche la liste des fichier disponibles\n\
		clean : nettoyer le projet"

clean:
	dune clean
	rm -f test/*_sch*.net

.PHONY: all sched graph list help clean 



