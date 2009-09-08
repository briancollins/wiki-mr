#!/usr/bin/env ruby

require 'rubygems'
require 'hpricot'
require 'cgi'
require 'memcached'

i = 0
buf = ""
store = Memcached.new("localhost:21201", :poll_timeout => 100, :recv_timeout => 100, :timeout => 100)

def valid_article(n)
  !(n =~ /^(Media|Special|Talk|User|User_talk|Wikipedia|Wikipedia_talk|Image|Image_talk|MediaWiki|MediaWiki_talk|Template|Template_talk|Help|Help_talk|Category|Category_talk):/i)
end

STDIN.each_line do |line|
  buf += line
  if line.include? "</page>"

    page = Hpricot(buf)
    title = CGI::escape((page/"title").inner_html)
    links = []
    (page/"text").inner_html.scan(/\[\[([^(\]\])]+)\]\]/) do |x|
      links << CGI::escape($1.split("|").first.strip.gsub(/^[a-z]/) { |a| a.upcase }.gsub(/[_\s]/, " "))
    end
    
    store.set("article:" + title, [1 / 97313, links.size, links])
    puts "#{title}\t#{links.size}"

    buf = ""
  end
end

  