# frozen_string_literal: true
class Parser
  A_COMMAND = 0
  C_COMMAND = 1
  L_COMMAND = 2
  AC_COMMANDS = [A_COMMAND, C_COMMAND]

  def initialize(input_file)
    @lines = File.readlines(input_file)
    @current_position = 0
    @command = ""
  end

  def has_more_commands?
    @current_position < @lines.size
  end

  def advance
    line = @lines[@current_position].gsub(/\/\/.*$/, "").strip
    @current_position += 1
    if line.empty?
      advance
    else
      @command = line
    end
  end

  def command_type
    case @command
    when /^@.*$/
      A_COMMAND
    when /^\(.*\)$/
      L_COMMAND
    else
      C_COMMAND
    end
  end

  def symbol
    match = @command.match(/^[@\(](.*?)\)?$/)
    match ? match[1] : ""
  end

  def dest
    match = @command.match(/^(.*?)=/)
    match ? match[1] : ""
  end

  def comp
    @command.gsub(/^.*?=/, "").gsub(/;.*$/, "")
  end

  def jump
    match = @command.match(/;(.*)$/)
    match ? match[1] : ""
  end
end
