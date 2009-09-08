#!/usr/bin/env ruby
require 'rubygems'
require 'memcached'

store = Memcached.new("localhost:21201", :poll_timeout => 100, :recv_timeout => 100, :timeout => 100)


STDIN.each_line do |line|
  key, val = line.split("\t", 2)
  if val.to_i == 0
    # page with no outbound links add pagerank to result
    page = store.get("article:" + key)
    store.set("val", store.get("val") + page[0])
  end
  store.increment("counter")
  puts line
end
