#!/usr/bin/env ruby

require 'rubygems'
require 'hpricot'

i = 0
buf = ""
STDIN.each_line do |line|
  buf += line
  if line.include? "</page>"

    page = Hpricot(buf)
    title = (page/"title").inner_html.gsub("\t", " ")
    i += 1
    puts "#{title}\t0"
    (page/"text").inner_html.scan(/\[\[([^(\]\])]+)\]\]/) do |x|
      puts "#{$1.split("|").first.strip.capitalize.gsub("\t", " ")}\t1"
    end

    buf = ""
  end
end
  