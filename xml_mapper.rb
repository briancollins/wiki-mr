#!/usr/bin/env ruby

require 'rubygems'
require 'hpricot'
require 'cgi'
require 'memcached'
require 'digest/md5'

i = 0
buf = ""
store = Memcached.new("localhost:21201", :poll_timeout => 100, :recv_timeout => 100, :timeout => 100)

def valid_article?(n)
  !(n =~ /^(Media|Special|Talk|User|User_talk|Wikipedia|Wikipedia_talk|Image|Image_talk|MediaWiki|MediaWiki_talk|Template|Template_talk|Help|Help_talk|Category|Category_talk):/i)
end

STDIN.each_line do |line|
  buf += line
  if line.include? "</page>"

    page = Hpricot(buf)
    title = (page/"title").inner_html
    links = []
    if valid_article?(title)
      (page/"text").inner_html.scan(/\[\[([^(\]\])]+)\]\]/) do |x|
        name = $1
        if valid_article?(name)
          links << CGI::escape(name.split("|").first.strip.gsub(/^[a-z]/) { |a| a.upcase }.gsub(/[_\s]/, " "))
        end
      end
    
      store.set("article:" + Digest::MD5.hexdigest(CGI::escape(title)), [1.0 / ENV["n"].to_i, links.size, links])
      puts "#{CGI::escape(title)}\t#{links.size}"
    end

    buf = ""
  end
end

  