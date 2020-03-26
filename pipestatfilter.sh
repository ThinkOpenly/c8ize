#!/bin/sh
while IFS='' read line; do
	case "$line" in
		HOT*|"Inst annotated disassembly")
			echo "$line"
			while IFS='' read l; do
				if [ "$l" = "" ]; then break; fi
				if [ "$l" = "Opcode Mix" ]; then break; fi
				echo "$l"
			done
			echo ""
			;;
	esac
done
				
