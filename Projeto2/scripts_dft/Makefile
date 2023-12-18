
# Remove the '#' to enable the graphical interface
GUI = -gui -access +r

CIRCUIT = circuito12

all:       circuit top_level FS_concurrent
circuit:   SYN_dft_circuit #SIM_rtl_circuit SYN_dft_circuit SIM_syn_scan_circuit
top_level: SIM_rtl_top_level_normal SIM_rtl_top_level_bist SIM_rtl_top_level_controller SYN_final\
           SIM_syn_top_level_normal SIM_syn_top_level_bist SIM_syn_top_level_controller

SIM_rtl_circuit:
	# Step 1: simulate the original circuit (behavioral simulation)
    # MULTIPLE STEP MODE
    #	xmvlog $(CIRCUIT).v tb_$(CIRCUIT).v
    #	xmelab -access +r tb_$(CIRCUIT):module
    #	xmsim -gui tb_$(CIRCUIT):module
    # SINGLE STEP MODE
	xrun $(GUI) b01.v b01_tb.v

SYN_dft_circuit:
	# Step 2: synthesize the circuit with scan chain
	genus -f synthesis_dft.tcl
	sed -i '1s/^/`timescale 1ns\/1ps /' circuito12.v

SIM_syn_scan_circuit:
	# Step 3 (OPTIONAL): simulate the original circuit with scan chain (gate-level simulation)
	xrun $(GUI) -l verilog.log\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/udp.v\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/c35b4/c35_CORELIB.v\
		<name of the Verilog file created in the synthesis>\
		<testbench to read the vectors file and apply them to the circuit>

HAL:
	# Step 4: check for good Verilog coding style 
	hal -gui <name of the Verilog file created in the synthesis> <your own Verilog files>

SIM_rtl_top_level_normal:
	# Step 5a (OPTIONAL): simulate the whole design in "normal mode"
	# Top Level (behavioral) + circuit with scan chain (gate-level)
	xrun $(GUI) -l verilog.log\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/udp.v\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/c35b4/c35_CORELIB.v\
		<name of the Verilog file created in the synthesis>\
		<your own Verilog files>\
		<testbench to test the whole design in "normal mode">

SIM_rtl_top_level_bist:
	# Step 5b (OPTIONAL): simulate the whole design in "bist mode"
	# Top Level (behavioral) + circuit with scan chain (gate-level)
	xrun $(GUI) -l verilog.log\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/udp.v\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/c35b4/c35_CORELIB.v\
		<name of the Verilog file created in the synthesis>\
		<your own Verilog files>\
		<testbench to test the whole design in "bist mode">

SIM_rtl_top_level_controller:
	# Step 5c (OPTIONAL): simulate the whole design in "controller mode"
	# Top Level (behavioral) + circuit with scan chain (gate-level)
	xrun $(GUI) -l verilog.log\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/udp.v\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/c35b4/c35_CORELIB.v\
		<name of the Verilog file created in the synthesis>\
		<your own Verilog files>\
		<testbench to test the whole design in "controller mode">

SYN_final:
	# Step 6: synthesize the Top Level
	# the circuit created in step 2 must be also included in this step
	genus -f Tools_for_DFT_files_AMS/scripts/synthesis.tcl
	sed -i '1s/^/`timescale 1ns\/1ps /' b01_scan_syn.v

SIM_syn_top_level_normal:
	# Step 7a: simulate the whole design in "normal mode" (gate-level simulation)
	xrun $(GUI) -l verilog.log\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/udp.v\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/c35b4/c35_CORELIB.v\
		<name of the Verilog file created in the final synthesis>\
		<testbench to test the whole design in "normal mode">

SIM_syn_top_level_bist:
	# Step 7b: simulate the whole design in "bist mode" (gate-level simulation)
	xrun $(GUI) -l verilog.log\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/udp.v\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/c35b4/c35_CORELIB.v\
		<name of the Verilog file created in the final synthesis>\
		<testbench to test the whole design in "bist mode">

SIM_syn_top_level_controller:
	# Step 7c: simulate the whole design in "controller mode" (gate-level simulation)
	xrun $(GUI) -l verilog.log\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/udp.v\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/c35b4/c35_CORELIB.v\
		<name of the Verilog file created in the final synthesis>\
		<testbench to test the whole design in "controller mode">

FS_concurrent:
	# Step 8: concurrent fault simulation
	# Elaborate
	xrun -clean -elaborate\
 		-define functional\
		-fault_file scripts/fault.file\
		-fault_top top_level\
		-fault_logfile fault_xrun_elab.log\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/udp.v\
		-v /opt/ic_tools/pdk/ams_c35_410/verilog/c35b4/c35_CORELIB.v\
		<name of the Verilog file created in the final synthesis>\
		<testbench to test the whole design in "bist mode">
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
		-input scripts/strobes.tcl\
		-input fault_list.tcl\
		-fault_logfile fault_xrun_sim.log
	# Generate the report
	xfr -verbose\
		-fault_work fault_db\
		-fault_report fault_report.txt\
		-log xfr.log

