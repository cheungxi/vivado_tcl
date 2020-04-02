set PROJDIR  [lindex $argv 0]
set RTL      [lindex $argv 1]
set SIM      [lindex $argv 2]
set XDC      [lindex $argv 3]
set RESULT   [lindex $argv 4]
set SIM_TIME [lindex $argv 5]
set PROJNAME projct_loongson
file mkdir $RESULT
if [catch {
create_project projct_loongson $PROJDIR -part xc7a200tfbg676-2
add_files $RTL
add_files -fileset sim_1 $SIM
add_files -fileset constrs_1 $XDC
# specify simulation top
set_property top testbench [get_filesets sim_1]
launch_simulation
restart
open_vcd 
log_vcd /testbench/*
run $SIM_TIME ns
flush_vcd
close_vcd
file copy $PROJDIR/$PROJNAME.sim/sim_1/behav/xsim/dump.vcd $RESULT/
# Lanunch Synthesis
launch_runs synth_1
wait_on_run synth_1
open_run synth_1 -name netlist_1
# Generate a timing and power repoets and write to disk
file mkdir $RESULT/report
report_timing_summary -delay_type max -report_unconstrained -check_timing_verbose \
    -max_paths 10 -input_pins -file $RESULT/report/syn_timing.rpt
report_power -file $RESULT/report/syn_power.rpt
# Launch Implementation
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
# Generate a timing and power reports and write to disk
open_run impl_1
report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose \
-max_paths 10 -input_pins -file $RESULT/report/imp_timing.rpt
report_power -file $RESULT/report/imp_power.rpt
file copy [glob ./test_project/projct_loongson.runs/impl_1/*.bit] $RESULT/
} errmsg] {
    set fp [open $RESULT/error.txt w+]
    puts $fp $errmsg
    close $fp
}
