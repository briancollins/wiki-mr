#!/usr/bin/env ruby
require 'rubygems'

require 'aws_sdb'
require 'digest/md5'
require 'base64'

class SimplerDB
  def initialize(domain)
    @store = AwsSdb::Service.new
    @domain = domain
    unless @store.list_domains.flatten.include? @domain
      @store.create_domain(@domain)
    end
  end

  def get(key)
    val = @store.get_attributes(@domain, Digest::MD5.hexdigest(key))
    unless val.empty?
      Marshal.load(Base64.decode64(val.keys.sort.collect { |k| val[k] }.join))
    end
  end

  def put(key, val)
    v = Base64.encode64(Marshal.dump(val)).scan /.{1023}|.+/
    attributes = {}
    v.each_with_index do |a, i|
      attributes[sprintf("key%09d", i)] = a
    end
    @store.put_attributes(@domain, Digest::MD5.hexdigest(key), attributes)
  end
end