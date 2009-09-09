#!/usr/bin/env ruby 
require 'rubygems'
require 'memcached'
require 'digest/md5'

store = Memcached.new("localhost:21201", :poll_timeout => 100, :recv_timeout => 100, :timeout => 100)

["Cat", "Dog", "Boat", "Account", "Debt", "Pikachu", "Limerick", "Hermione+Granger", "United+States", "England", "Linux", "Ireland", "Cancer", "Watermelon"].each do |k|
  begin
    printf "%s %.10f\n", k, store.get("article:" + Digest::MD5.hexdigest(k))[0]
  rescue
    printf "%s 0\n", k
  end
end