#!/usr/bin/env ruby
require 'rubygems'
require 'memcached'
require 'digest/md5'

store = Memcached.new("voldemort:21201", :poll_timeout => 100, :recv_timeout => 100, :timeout => 100)

STDIN.each_line do |line|
  key, val = line.split("\t", 2)

  # remove dead links
  page = store.get("article:" + Digest::MD5.hexdigest(key))
  page[2] = page[2].select do |link|
    begin
      store.get("article:" + Digest::MD5.hexdigest(link))
      true
    rescue Memcached::NotFound
      false
    end
  end
  page[1] = page[2].size
  
  store.set("article:" + Digest::MD5.hexdigest(key), page)

  puts line
end