#!/usr/bin/env ruby
require 'rubygems'
require 'memcached'

ARTICLE_COUNT = 97313
store = Memcached.new("voldemort:21201", :poll_timeout => 100, :recv_timeout => 100, :timeout => 100)
store.set 'val', 0.0

`hadoop dfs -rmr ip`
`hadoop jar ./streaming.jar \
    -input result \
    -output ip \
    -mapper ip_mapper.rb \
    -reducer aggregate \
    -cmdenv n=#{ARTICLE_COUNT} \
	  -file ip_mapper.rb`
	
ip = `hadoop fs -cat "ip/*"`
ip = ip.split("\t").last.to_f
puts ip
`hadoop dfs -rmr mapped`
`hadoop dfs -mv result mapped`

`hadoop jar ./streaming.jar \
    -input mapped \
    -output result \
    -mapper pr_mapper.rb \
    -reducer pr_reducer.rb \
    -cmdenv n=#{ARTICLE_COUNT} \
    -cmdenv ip=#{ip} \
	  -file pr_mapper.rb \
	  -file pr_reducer.rb`
