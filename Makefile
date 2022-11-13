file = fulladder
n = 

all: netlist_simulator.byte
ifndef n
	dune exec ./netlist_simulator.exe test/$(file).net
else
	dune exec -- ./netlist_simulator.exe -n $(n)  test/$(file).net
endif

netlist_simulator.byte:
	dune build netlist_simulator.exe

clean:
	dune clean
	rm -f test/*_sch*.net
	find -name '*~' -delete

.PHONY: all clean 



