# Cadence GENUS

# Paths
set LIB_DIR "/opt/ic_tools/pdk/ams_c35_410/liberty/c35_3.3V"
set_db init_lib_search_path $LIB_DIR
set_db init_hdl_search_path {.}

# Read the library
read_libs c35_CORELIB_TYP.lib

# Read the circuit
read_hdl circuito12.v

# Elaboration (pre-synthesis)
elaborate circuito12

# Analyze the design
check_design

# Define the name of the clock signal and its frequency
######## IMPORTANT ########
#### THE SIGNAL NAMED "clock" MAY NEED TO BE REPLACED
#### BY THE NAME OF THE CLOCK IN YOUR CIRCUIT
create_clock -name clk -period 10000 [get_ports clk]

# Read the constraints from an SDC file
#read_sdc <SDC file>

# Define the scan type
set_db dft_scan_style muxed_scan

# Define the scan ports
define_dft shift_enable -active high -create_port scan_en
######## IMPORTANT ########
#### THE SIGNAL NAMED "clock" MAY NEED TO BE REPLACED
#### BY THE NAME OF THE CLOCK IN YOUR CIRCUIT
define_dft test_clock -name scan_clk clk

# Check for DFT violations
check_dft_rules > dft_rules.report

# Synthesize
set_db syn_global_effort high
syn_generic
syn_map

# Generate report
report dft_registers

# Create the scan chain
define_dft scan_chain -name chain1 -create_ports -sdi scan_in -sdo scan_out
connect_scan_chains -auto_create_chains -preview
connect_scan_chains -auto_create_chains

# Generate reports
report qor
write_hdl -mapped > circuito_scan_syn.v 
write_sdc > circuito_scan.sdc
write_scandef > circuito_scan_chain.txt
write_atpg -stil > circuito_scan.stil
report gates > circuito_scan_gates.txt
report timing > circuito_scan_timing.txt
report power > circuito_power.txt

exit
