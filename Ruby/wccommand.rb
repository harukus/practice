#! /usr/bin/env ruby
# frozen_string_literal: true

require "optparse"

class Wc
  def initialize
    @lines = 0
    @words_counts = 0
    @bytes = 0
  end

  def option
    OptionParser.new do |opt|
      opt.on("-l") { |v| @is_long = true }
      opt.parse!
    end
  end

  def run
    option
    if ARGV.count == 0
      standard_input
      return
    end
    if @is_long
      long_option
    else
      no_option
    end
  end

  def long_option
    ARGV.each { |f|
      if FileTest.directory? f
        puts "wc: #{f}: read: Is a directory"
        next
      end
      details = File.read(f)
      puts "#{line(details).to_s.rjust(7)} #{f}"
    }
    if ARGV.count != 1
      puts "#{lines_total.to_s.rjust(7)} total"
    end
  end

  def no_option
    ARGV.each { |f|
      if FileTest.directory? f
        puts "wc: #{f}: read: Is a directory"
        next
      end
      details = File.read(f)
      result_display(details, f)
    }
    if ARGV.count != 1
      puts "#{lines_total.to_s.rjust(7)} #{words_total.to_s.rjust(7)} #{bytes_total.to_s.rjust(7)} total"
    end
  end

  def standard_input
    ARGF.each { |line|
      @lines += line.count("\n")
      @words_counts += line.split(" ").size
      @bytes += line.bytesize
    }
    puts "#{@lines.to_s.rjust(8)}#{@words_counts.to_s.rjust(8)}#{@bytes.to_s.rjust(8)}"
  end

  def result_display(file, file_name)
    puts "#{line(file).to_s.rjust(7)} #{word(file).to_s.rjust(7)} #{byte(file).to_s.rjust(7)} #{file_name}"
  end

  def file_identify
    whether_file = ARGV.filter { |f| FileTest.file?(f) }
    whether_file.map { |f| File.read(f) }
  end

  def line(file)
    file.count("\n")
  end

  def word(file)
    file.split(" ").size
  end

  def byte(file)
    file.bytesize
  end

  def lines_total
    file_identify.map { |file| line(file) }.sum
  end

  def words_total
    file_identify.map { |file| word(file) }.sum
  end

  def bytes_total
    file_identify.map { |file| byte(file) }.sum
  end
end

wc_command = Wc.new
wc_command.run
