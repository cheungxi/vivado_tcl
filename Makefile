REPORT  := ./result/report
PROJDIR := ./test_project
TCL := vivado.tcl
SIM := ./example_src/sim
XDC := ./example_src/xdc
RTL := ./example_src/rtl
RESULT := ./result
SIM_TIME := 10000

all: $(TCL)
	@vivado -mode batch -source $(TCL) \
               -tclargs $(PROJDIR) $(RTL) $(SIM) $(XDC) $(RESULT) $(SIM_TIME)\
               origin_dir .

clean: 
	rm -rf $(PROJDIR)
	rm -rf $(RESULT)
