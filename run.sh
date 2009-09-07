#!/bin/sh

hadoop dfs -rmr result
hadoop jar ./streaming.jar \
    -input articles.xml \
    -output result \
	-inputreader 'StreamXmlRecordReader,begin=<page>,end=</page>' \
    -mapper ~/Projects/mapreduce/map.rb \
	-reducer ~/Projects/mapreduce/reduce.rb \
	