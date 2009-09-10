#!/usr/bin/env ruby 
require 'rubygems'
require 'simplerdb'

store = SimplerDB.new("enwiki")

STDIN.each_line do |line|
  key, val = line.split("\t", 2)
  page = store.get(key)
  printf "%.14f\t%s\n", page[0], key
end