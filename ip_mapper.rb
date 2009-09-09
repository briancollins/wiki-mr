#!/usr/bin/env ruby
require 'rubygems'
require 'memcached'
require 'digest/md5'

store = Memcached.new("voldemort:21201", :poll_timeout => 100, :recv_timeout => 100, :timeout => 100)


STDIN.each_line do |line|
  key, val = line.split("\t", 2)

  if val.to_i == 0
    # page with no outbound links add pagerank to result
    page = store.get("article:" + Digest::MD5.hexdigest(key))
    printf "DoubleValueSum:result\t%.14f\n",page[0]
  end
end
