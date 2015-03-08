#!/usr/bin/env bash

# define used temp tables
TEMP_TABLE1="${TEMP_TABLE}_sessions"
TEMP_TABLE2="${TEMP_TABLE}_cart_abandon"

BINARY_PARAMS="$BINARY_PARAMS --hiveconf TEMP_TABLE1=$TEMP_TABLE1 --hiveconf TEMP_TABLE2=$TEMP_TABLE2"

PY_FILE1="$BIG_BENCH_QUERIES_DIR/q04/q4_reducer1.py"
PY_FILE2="$BIG_BENCH_QUERIES_DIR/q04/q4_reducer2.py"

BINARY_PARAMS="$BINARY_PARAMS --files $PY_FILE1,$PY_FILE2"

query_run_main_method () {
	QUERY_SCRIPT="$QUERY_DIR/$QUERY_NAME.sql"
	if [ ! -r "$QUERY_SCRIPT" ]
	then
		echo "SQL file $QUERY_SCRIPT can not be read."
		exit 1
	fi

        runCmdWithErrorCheck runEngineCmd -f "$QUERY_SCRIPT"
}

query_run_clean_method () {
	runCmdWithErrorCheck runEngineCmd -e "DROP VIEW IF EXISTS $TEMP_TABLE1; DROP VIEW IF EXISTS $TEMP_TABLE2; DROP TABLE IF EXISTS $RESULT_TABLE;"
}
