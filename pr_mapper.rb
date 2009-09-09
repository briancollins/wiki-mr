#!/usr/bin/env ruby 
require 'rubygems'
require 'memcached'
require 'digest/md5'

store = Memcached.new("voldemort:21201", :poll_timeout => 100, :recv_timeout => 100, :timeout => 100)

STDIN.each_line do |line|
  key, val = line.split("\t", 2)

  page = store.get("article:" + Digest::MD5.hexdigest(key))
  puts "#{key}\t0"
  page[2].each do |link|
    printf("%s\t%.14f\n", link, page[0].to_f / page[1])
  end
end