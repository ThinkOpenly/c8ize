#!/bin/sh
for i in $(perf list --raw-dump metric); do
  perf stat --metrics $i --metric-only --no-big-num --field-separator=: $@
done
