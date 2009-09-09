#!/usr/bin/env ruby 
require 'rubygems'
require 'memcached'
require 'digest/md5'

store = Memcached.new("localhost:21201", :poll_timeout => 100, :recv_timeout => 100, :timeout => 100)

PR = 0.85
IP = ENV["ip"].to_f
N = ENV["n"].to_i

current_key = nil
sum = 0
STDIN.each_line do |line|
  key, val = line.split("\t", 2)
  if current_key.nil? || current_key == key
    current_key = key
    sum += val.to_f
  else
    pagerank = (PR * sum) + (PR * (IP / N)) + ((1.0 - PR) / N)
    article = store.get("article:" + Digest::MD5.hexdigest(current_key))
    article[0] = pagerank
    store.set("article:" + Digest::MD5.hexdigest(current_key), article)
    
    puts "#{current_key}\t#{article[1]}"
    
    current_key = key
    sum = val.to_f
  end
end