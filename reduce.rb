#!/usr/bin/ruby

current_key = nil
count = 0
STDIN.each_line do |line|
  key, val = line.split("\t", 2)
  count += val.to_i
  if key != current_key
    if current_key
      puts "#{current_key}\t#{count}"
      count = 0
    end

    current_key = key
  end
end

if count > 0
  puts "#{current_key}\t#{count}"
end