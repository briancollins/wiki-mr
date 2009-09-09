#!/usr/bin/env ruby 
require 'rubygems'
require 'memcached'
require 'digest/md5'

store = Memcached.new("localhost:21201", :poll_timeout => 100, :recv_timeout => 100, :timeout => 100)

STDIN.each_line do |line|
  key, val = line.split("\t", 2)
  page = store.get("article:" + Digest::MD5.hexdigest(key))
  printf "%.14f\t%s\n", page[0], key
end