#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './translator'
infile = ARGV[0]
raise 'Must have a file path as argument' unless infile

if File.directory?(infile)
  dirs = Dir.glob(File.join(infile, '**/*.vm'))
  raise 'No vm files found' if dirs.empty?

  dirs.each do |file|
    Translator.new(file).translate
  end
else
  Translator.new(infile).translate
end
