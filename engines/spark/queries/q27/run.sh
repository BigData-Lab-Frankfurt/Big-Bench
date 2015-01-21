#!/usr/bin/env bash

JAR_FILE1="$BIG_BENCH_QUERIES_DIR/Resources/opennlp-maxent-3.0.3.jar"
JAR_FILE2="$BIG_BENCH_QUERIES_DIR/Resources/opennlp-tools-1.5.3.jar"
JAR_FILE3="$BIG_BENCH_QUERIES_DIR/Resources/bigbenchqueriesmr.jar"

BINARY_PARAMS="$BINARY_PARAMS --jars $JAR_FILE1,$JAR_FILE2,$JAR_FILE3"

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
	runCmdWithErrorCheck runEngineCmd -e "DROP TABLE IF EXISTS $TEMP_TABLE; DROP TABLE IF EXISTS $RESULT_TABLE;"
}
