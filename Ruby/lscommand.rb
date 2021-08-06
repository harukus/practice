#! /usr/bin/env ruby
# frozen_string_literal: true

require "etc"
require "fileutils"
require "optparse"

class Ls
  def initialize(path = ".", is_all = false, is_reverse = false, is_long = false)
    @path = path
    @is_all = is_all
    @is_reverse = is_reverse
    @is_long = is_long
  end

  def hensu(file)
    File.stat("#{@path}/#{file}")
  end

  def run
    files = Dir.entries(@path).sort
    if @is_reverse
      files = files.reverse
    end
    if !@is_all
      files = files.filter { |fname| !fname.start_with?(".") }
    end
    if @is_long
      puts total(files)
      long_show(files)
    else
      puts files.join(" ")
    end
  end

  def total(files)
    blocks = []
    files.map do |file|
      blocks << hensu(file).blocks
    end
    "total #{blocks.inject(:+)}"
  end

  def permission(mode)
    permission_hash = { "7" => "rwx", "6" => "rw-", "5" => "r-x", "4" => "r--", "3" => "-wx",
      "2" => "-w-", "1" => "--x", "0" => "---" }
    mode.chars.last(3).map { |n| permission_hash[n] }.join("")
  end

  def file_type(mode)
    file_type_hash = { "40" => "d", "100" => "-" }
    file_type_hash [mode.chars[0...-3].join("")]
  end

  def file_detail(file)
    mode = sprintf("%o", hensu(file).mode)
    [file_type(mode)+permission(mode),
    hensu(file).nlink.to_s,
    Etc.getpwuid(hensu(file).uid).name,
    Etc.getgrgid(hensu(file).gid).name,
    hensu(file).size?,
    hensu(file).ctime.month,
    hensu(file).ctime.day,
    hensu(file).ctime.strftime("%H:%M")]
  end

  def long_show(files)
    file_details = files.map { |file| file_detail(file) }
    # ファイルの詳細のそれぞれの列の最大の長さを求める（ファイル名以外）
    column_length = file_details.transpose.map { |a| a.map(&:to_s).map(&:length).max }
    file_details.map { |a|
      # 求めた最大の長さに合わせて右詰にし、ファイル名と合わせて表示
      a.zip(column_length).map { |v, l| v.to_s.rjust(l) }.join(" ")
    }.zip(files).each { |detail, file| puts "#{detail} #{file}" }
  end
end

option = { a: false, r: false, l: false }
path = "."
OptionParser.new do |opt|
  opt.on("-a") { |v| option[:a] = true }
  opt.on("-l") { |v| option[:l] = true }
  opt.on("-r") { |v| option[:r] = true }
  argv = opt.parse!
  if argv.length > 0
    path = argv[0]
  end
end

ls = Ls.new(path, option[:a], option[:r], option[:l])
ls.run
