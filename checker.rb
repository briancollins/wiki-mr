#!/usr/bin/env ruby 
require 'rubygems'
require 'memcached'
require 'digest/md5'

store = Memcached.new("voldemort:21201", :poll_timeout => 100, :recv_timeout => 100, :timeout => 100)

prev = 1
["United+States", "English+language", "Germany", "England", "France", "United+Kingdom", "Japan", "Europe", "2007", "Italy", "Country", "City", "Spain", "Canada"].each do |k|
  begin
    article = store.get("article:" + Digest::MD5.hexdigest(k))
    if prev == article[0]
      printf "="
    elsif prev < article[0]
      printf ">"
    elsif prev > article[0]
      printf "<"
    end
    
    prev = article[0]
    printf " %.10f %s\n", prev, k
    
  rescue
    if prev == 0
      printf "="
    elsif prev < 0
      printf ">"
    elsif prev > 0
      printf "<"
    end
    prev = 0
    printf " 0 %s\n", k
  end
end