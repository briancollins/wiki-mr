#!/usr/bin/env ruby
require 'rubygems'
require 'memcached'

store = Memcached.new("localhost:21201", :poll_timeout => 100, :recv_timeout => 100, :timeout => 100)
store.set 'counter', 0
store.set 'val', 0.0

`hadoop dfs -rmr result
hadoop jar ./streaming.jar \
    -input articles.xml \
    -output result \
	  -inputreader 'StreamXmlRecordReader,begin=<page>,end=</page>' \
    -mapper init.rb \
    -reducer ip_mapper.rb \
	  -file init.rb \
	  -file ip_mapper.rb`
	

	