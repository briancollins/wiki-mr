#!/usr/bin/env ruby
require 'rubygems'
require 'memcached'

ARTICLE_COUNT = 97313
store = Memcached.new("localhost:21201", :poll_timeout => 100, :recv_timeout => 100, :timeout => 100)
store.set 'counter', 0


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
	
	
