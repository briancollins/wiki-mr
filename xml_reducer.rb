#!/usr/bin/env ruby
require 'rubygems'
require 'simplerdb'

store = SimplerDB.new

STDIN.each_line do |line|
  key, val = line.split("\t", 2)

  # remove dead links
  page = store.get(key)
  page[2] = page[2].select do |link|
    store.get(link)
  end

  page[1] = page[2].size
  
  store.set(key, page)

  puts line
end