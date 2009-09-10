#!/usr/bin/env ruby
require 'rubygems'

ARTICLE_COUNT = 3000000

`hadoop dfs -rmr result
hadoop jar ./streaming.jar \
    -input articles.xml \
    -output result \
	  -inputreader 'StreamXmlRecordReader,begin=<page>,end=</page>' \
    -mapper xml_mapper.rb \
    -reducer xml_reducer.rb \
    -cmdenv n=#{ARTICLE_COUNT} \
	  -file xml_mapper.rb \
	  -file xml_reducer.rb`
	
	
