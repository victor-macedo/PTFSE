# Cadence GENUS

# Paths
set LIB_DIR "/opt/ic_tools/pdk/ams_c35_410/liberty/c35_3.3V"
set_db init_lib_search_path $LIB_DIR
set_db init_hdl_search_path {.}

# Read the library
read_libs c35_CORELIB_TYP.lib

# Read the circuit
read_hdl ./circuito_scan_syn.v ./sources/main.v ./sources/MISR.v ./sources/Bist_Control.v ./sources/LFSR.v ./sources/Comparador.v

# Elaboration (pre-synthesis)
elaborate main

# Analyze the design
check_design

# Define the name of the clock signal and its frequency
create_clock -name clk -period 10000 [get_ports CLK]

# Read the constraints from an SDC file
#read_sdc <SDC file>

# Synthesize
set_db syn_global_effort high
syn_generic
syn_map

# Create a flatten circuit (circuit with only one module) 
ungroup -all

# Generate reports
report qor
write_hdl -mapped > circuito_syn.v 
write_sdc > circuito.sdc
report gates > circuito_gates.txt
report timing > circuito_timing.txt
report power > circuito_power.txt

exit
