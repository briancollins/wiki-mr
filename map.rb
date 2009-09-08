#!/usr/bin/env ruby

require 'rubygems'
require 'hpricot'
require 'cgi'

require 'syslog'
i = 0
buf = ""
link = ""
title = ""
begin
STDIN.each_line do |line|
  buf += line
  if line.include? "</page>"

    page = Hpricot(buf)
    title = (page/"title").inner_html.gsub("\t", " ")
    i += 1
    puts "LongValueSum:#{CGI::escape title}\t0"
    (page/"text").inner_html.scan(/\[\[([^(\]\])]+)\]\]/) do |x|
      link = $1.split("|").first.strip.gsub(/^[a-z]/) { |a| a.upcase }.gsub(/\t|_/, " ")
      puts "LongValueSum:#{CGI::escape link}\t1"
    end

    buf = ""
  end
end
rescue
  Syslog.open("HJALP")
  Syslog.crit("#{link}, #{title}")
end
  