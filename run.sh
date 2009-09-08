#!/bin/sh

hadoop dfs -rmr result
hadoop jar ./streaming.jar \
    -input articles.xml \
    -output result \
	-inputreader 'StreamXmlRecordReader,begin=<page>,end=</page>' \
    -mapper map.rb \
	-reducer reduce.rb \
	-file map.rb \
	-file reduce.rb
	