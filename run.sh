#!/bin/sh

~/hadoop/bin/hadoop dfs -rmr /user/brian/result
~/hadoop/bin/hadoop jar ./streaming.jar \
    -input /user/brian/articles.xml \
    -output /user/brian/result \
	-inputreader 'StreamXmlRecordReader,begin=<page>,end=</page>' \
    -mapper ~/Projects/mapreduce/map.rb \
	-reducer ~/Projects/mapreduce/reduce.rb \
	