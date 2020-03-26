#!/bin/sh
echo "
TravisCI integration

perf stat & record
- all hardware counters
- all metrics
- all metric groups
- all software tracepoints
- drilldown
curt
splat
LPCPU(isms)
pipestat (instruction trace (Valgrind itrace / Mambo)
*Mambo record-all PMU events?
*look for phases?
*presentation
- flamegraphs
" >/dev/null

PID=$$

# all hardware events
rm -f "$PID".pmucounts
./pmucounts.sh --output "$PID".pmucounts --append $@

# all metrics
rm -f "$PID".perfmetrics
./perfmetrics.sh --output "$PID".perfmetrics --append $@

instructions=""
if perf stat -e instructions --no-big-num --field-separator=: -o "$PID".instructions $@
then
	instructions=$(tail -1 "$PID".instructions | cut -f1 -d:)
fi
rm -f "$PID".instructions
if [ "$instructions" = "" ]; then
	echo "Defaulting to 1000000 instructions"
	instructions=1000000
fi
valgrind --tool=itrace --trace-extent=all --binary-outfile="$PID".vgi --demangle=no $@
vgi2qt -f "$PID".vgi -o "$PID".qt
/opt/ibm/sim_ppc/sim_p9/bin/run_timer "$PID".qt "$instructions" 10000 1 "$PID" -scroll_pipe 1 -scroll_begin 1 -scroll_end "$instructions"

/opt/ibm/pipestat/bin/pipestat -o "$PID".pipestat "$PID".pipe
