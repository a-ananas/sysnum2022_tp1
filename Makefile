file = fulladder
n = 
list = "clock_div cm2 fulladder nadder ram"


all: netlist_simulator.byte
ifndef n
	dune exec ./netlist_simulator.exe test/$(file).net
else
	dune exec -- ./netlist_simulator.exe -n $(n)  test/$(file).net
endif

netlist_simulator.byte:
	dune build netlist_simulator.exe

list: 
	@echo "liste des valeurs possibles pour \`file\` : "$(list)

clean:
	dune clean
	rm -f test/*_sch*.net

.PHONY: all clean list



