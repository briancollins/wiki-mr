#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'

i = 0
buf = ""
STDIN.each_line do |line|
  buf += line
  if line.include? "</page>"

    page = Nokogiri(buf)
    title = (page/"title").inner_html.gsub("\t", "")
    i += 1
    (page/"text").inner_html.scan(/\[\[([^(\]\])]+)\]\]/) do |x|
      puts "#{title}\t#{$1.split("|").first.strip.capitalize}"
    end

    buf = ""
  end
end
  