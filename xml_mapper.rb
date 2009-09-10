#!/usr/bin/env ruby

require 'rubygems'
require 'hpricot'
require 'simplerdb'
require 'cgi'

i = 0
buf = ""
store = SimplerDB.new("enwiki")

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
        begin
          if valid_article?(name)
            links << CGI::escape(name.split("|").first.strip.gsub(/^[a-z]/) { |a| a.upcase }.gsub(/[_\s]/, " "))
          end
        rescue
          # bad link
        end
      end
    
      store.put(CGI::escape(title), [1.0 / ENV["n"].to_i, links.size, links])
      puts "#{CGI::escape(title)}\t#{links.size}"
    end

    buf = ""
  end
end

  