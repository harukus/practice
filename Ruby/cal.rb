#! /usr/bin/ruby
require 'optparse'
require 'date'

today = Date.today
option = {y: today.year, m: today.month}
OptionParser.new do |opt|
  opt.on('-y [value]') {|v| option[:y] = v.to_i}
  opt.on('-m [value]') {|v| option[:m] = v.to_i}
  opt.parse!
end

last_date = Date.new(option[:y], option[:m], -1)
first_date = Date.new(option[:y], option[:m], 1)

puts "       #{option[:m]}月#{option[:y]} "
puts "日 月 火 水 木 金 土"

days = 1.upto(last_date.day).map{|n| n.to_s.rjust(2)}
spaces = Array.new(first_date.wday, "  ")
[*spaces, *days].each_slice(7){|arr| puts arr.join(" ")}
