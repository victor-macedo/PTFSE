
# Remove the '#' to enable the graphical interface
GUI = -gui -access +r

CIRCUIT = circuito12

all:       circuit top_level FS_concurrent
circuit:   SYN_dft_circuit
top_level: SYN_final SIM_syn_top_level_normal SIM_syn_top_level_bist SIM_syn_top_level_controller

SIM_rtl_circuit:
	# Step 1: simulate the original circuit (behavioral simulation)
    # MULTIPLE STEP MODE
    #	xmvlog $(CIRCUIT).v tb_$(CIRCUIT).v xmelab -access +r tb_$(CIRCUIT):module xmsim -gui tb_$(CIRCUIT):module
    # SINGLE STEP MODE
	xrun $(GUI) ./sources/circuito12.v ./testbenches/teste_normal_sembist.v

SYN_dft_circuit:
	# Step 2: synthesize the circuit with scan chain
	genus -f ./scripts/synthesis_dft.tcl
	sed -i '1s/^/`timescale 1ns\/1ps /' ./sources/circuito12.v

HAL:
	# Step 4: check for good Verilog coding style 
	hal -gui ./sources/main.v ./sources/LFSR.v ./sources/MISR.v ./sources/Bist_Control.v ./circuito_scan_syn.v


SYN_final:
	# Step 6: synthesize the Top Level
	# the circuit created in step 2 must be also included in this step
	genus -f ./scripts/synthesis.tcl
	sed -i '1s/^/`timescale 1ns\/1ps /' ./circuito_syn.v


SIM_syn_top_level_normal:
	# Step 7a: simulate the whole design in "normal mode" (gate-level simulation)
	xrun $(GUI) -l verilog.log\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/udp.v\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/c35b4/c35_CORELIB.v\
		./circuito_syn.v\
		./testbenches/testbench_normal.v

SIM_syn_top_level_bist:
	# Step 7b: simulate the whole design in "bist mode" (gate-level simulation)
	xrun $(GUI) -l verilog.log\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/udp.v\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/c35b4/c35_CORELIB.v\
		./circuito_syn.v\
		./testbenches/test_bench.v

SIM_syn_top_level_controller:
	# Step 7c: simulate the whole design in "controller mode" (gate-level simulation)
	xrun $(GUI) -l verilog.log\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/udp.v\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/c35b4/c35_CORELIB.v\
		./sources/Bist_Control.v\
		./testbenches/teste_control.v

FS_concurrent:
	# Step 8: concurrent fault simulation
	# Elaborate
	xrun -clean -elaborate\
 		-define functional\
		-fault_file ./scripts/fault.file\
		-fault_top main\
		-fault_logfile fault_xrun_elab.log\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/udp.v\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/c35b4/c35_CORELIB.v\
		./circuito_syn.v ./testbenches/test_bench.v
	# Generate the fault list
	xfsg -fault_type SA0+SA1\
		-fault_list fault_list\
		-fault_work fault_db
	# Remove UNCONNECTED signals (e.g. outputs of FFs)
	sed '/UNCONNECTED/d' -i fault_list.tcl
	# Perform fault simulation
	xrun -R -fault_concurrent\
		-nospecify -notimingchecks -delay_mode zero -run -exit\
		-define functional\
		-input ./scripts/strobes.tcl\
		-input fault_list.tcl\
		-fault_logfile ./fault_xrun_sim.log
	# Generate the report
	xfr -verbose\
		-fault_work fault_db\
		-fault_report fault_report.txt\
		-log xfr.log

