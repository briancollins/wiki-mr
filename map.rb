#!/usr/bin/env ruby

require 'rubygems'
require 'hpricot'
require 'cgi'

require 'syslog'
i = 0
buf = ""

STDIN.each_line do |line|
  buf += line
  if line.include? "</page>"

    page = Hpricot(buf)
    title = (page/"title").inner_html.gsub("\t", " ")
    i += 1
    puts "#{CGI::escape title}\t0"
    (page/"text").inner_html.scan(/\[\[([^(\]\])]+)\]\]/) do |x|
      link = $1.split("|").first.strip.gsub(/^[a-z]/) { |a| a.upcase }.gsub(/\t|_/, " ")
      puts "#{CGI::escape link}\t1\t"
    end

    buf = ""
  end
end

  