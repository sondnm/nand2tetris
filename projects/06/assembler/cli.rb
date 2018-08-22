#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "./assembler"
infile = ARGV[0]
raise "Must have a file path as argument" unless infile
Assembler.new(infile).assemble
