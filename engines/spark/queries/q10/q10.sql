--For all products, extract sentences from its product reviews that con-
--tain Positive or Negative sentiment and display the sentiment polarity of the
--extracted sentences.

-- Resources
ADD JAR ${env:BIG_BENCH_QUERIES_DIR}/Resources/opennlp-maxent-3.0.3.jar;
ADD JAR ${env:BIG_BENCH_QUERIES_DIR}/Resources/opennlp-tools-1.5.3.jar;
ADD JAR ${env:BIG_BENCH_QUERIES_DIR}/Resources/bigbenchqueriesmr.jar;
CREATE TEMPORARY FUNCTION extract_sentiment AS 'de.bankmark.bigbench.queries.q10.SentimentUDF';

-- Query parameters

--Result  --------------------------------------------------------------------
--keep result human readable
set hive.exec.compress.output=false;
set hive.exec.compress.output;

--CREATE RESULT TABLE. Store query result externally in output_dir/qXXresult/
DROP TABLE IF EXISTS ${hiveconf:RESULT_TABLE};
CREATE TABLE ${hiveconf:RESULT_TABLE} (
  pr_item_sk      BIGINT,
  review_sentence STRING,
  sentiment       STRING,
  sentiment_word  STRING
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n'
STORED AS ${env:BIG_BENCH_hive_default_fileformat_result_table} LOCATION '${hiveconf:RESULT_DIR}';

-- the real query part
INSERT INTO TABLE ${hiveconf:RESULT_TABLE}
-- workaround to get user function working with spark
-- (see http://apache-spark-user-list.1001560.n3.nabble.com/Spark-SQL-Assigning-several-aliases-to-the-output-several-return-values-of-an-UDF-td21238.html)
SELECT `result._c0` AS pr_item_sk, `result._c1` AS review_sentence, `result._c2` AS sentiment, `result._c3` AS sentiment_word
FROM (
  SELECT extract_sentiment(pr.pr_item_sk,pr.pr_review_content) AS return
  FROM product_reviews pr
) result
;