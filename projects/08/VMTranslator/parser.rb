# frozen_string_literal: true

class Parser
  C_ARITHMETIC = 0
  C_PUSH = 1
  C_POP = 2
  C_LABEL = 3
  C_GOTO = 4
  C_IF = 5
  C_FUNCTION = 6
  C_RETURN = 7
  C_CALL = 8

  def initialize(infile)
    @lines = File.readlines(infile)
    @current_position = 0
    @command = ''
  end

  def has_more_commands?
    @current_position < @lines.length
  end

  def advance
    line = @lines[@current_position].sub(/\/\/.*/, '').strip
    @current_position += 1
    if line.empty?
      advance
    else
      @command = line
    end
  end

  def command_type
    case @command
    when /^add|sub|neg|eq|gt|lt|and|or|not/
      C_ARITHMETIC
    when /^push/
      C_PUSH
    when /^pop/
      C_POP
    when /^label/
      C_LABEL
    when /^goto/
      C_GOTO
    when /^if/
      C_IF
    when /^function/
      C_FUNCTION
    when /^return/
      C_RETURN
    when /^call/
      C_CALL
    else
      ''
    end
  end

  # should not be called if command type is C_RETURN
  def arg1
    case command_type
    when C_ARITHMETIC
      @command
    when C_RETURN
      raise 'Cannot be called'
    else
      @command.split[1]
    end
  end

  def arg2
    if [C_PUSH, C_POP, C_FUNCTION, C_CALL].include?(command_type)
      @command.split[2].to_i
    else
      raise 'Cannot be called'
    end
  end
end
