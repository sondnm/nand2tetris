# frozen_string_literal: true

require_relative './parser'

class CodeWriter
  def initialize(outfile)
    @outfile = File.open(outfile, 'w')
    @boolean_command_counter = 0
    @function_name = "null"
  end

  def set_file_name(filename)
    File.basename(filename, '.asm')
  end

  def write_init
    commands = <<~COMMANDS
      @256
      D=A
      @SP
      M=D
    COMMANDS

    @outfile.puts commands
    write_call("Sys.init", 0)
  end

  def write_arithmetic(command)
    commands = case command
               when 'add'
                 arithmetic_command_template('M=D+M')
               when 'sub'
                 arithmetic_command_template('M=M-D')
               when 'and'
                 arithmetic_command_template('M=D&M')
               when 'or'
                 arithmetic_command_template('M=D|M')
               when 'not'
                 arithmetic_command_template(%w[M=!M @SP M=M+1].join("\n"), single_input: true)
               when 'neg'
                 arithmetic_command_template(%w[M=-M @SP M=M+1].join("\n"), single_input: true)
               when 'eq', 'gt', 'lt'
                 command = arithmetic_command_template(
                   <<~COMMANDS
                     D=M-D
                     @SP
                     A=M-1
                     M=-1
                     @CONTINUE#{@boolean_command_counter}
                     D;J#{command.upcase}
                     @SP
                     A=M-1
                     M=0
                     (CONTINUE#{@boolean_command_counter})
                   COMMANDS
                 )
                 @boolean_command_counter += 1
                 command
               end
    @outfile.puts commands
  end

  def write_push_pop(command, segment, index)
    return unless [Parser::C_PUSH, Parser::C_POP].include? command

    commands = if command == Parser::C_PUSH
                 push_command(segment, index)
               elsif command == Parser::C_POP
                 pop_command(segment, index)
               end
    @outfile.puts commands
  end

  def write_label(label)
    @outfile.puts "(#{@function_name}$#{label})"
  end

  def write_goto(label)
  end

  def write_if(label)
    commands = <<~COMMANDS
      @SP
      AM=M-1
      D=M
      @#{@function_name}$#{label}
      0;JEQ
    COMMANDS

    @outfile.puts commands
  end

  def write_call(function_name, number_of_arguments)
    @function_name = function_name
  end

  def write_return
  end

  def write_function(function_name, number_of_locals)
  end

  def close
    @outfile.close
  end

  private

  def arithmetic_command_template(operation, single_input: false)
    <<~COMMANDS
      @SP
      AM=M-1
      #{%w[D=M A=A-1].join("\n") unless single_input}
      #{operation}
    COMMANDS
  end

  def push_command_template(register, index, is_direct: false, is_offset: true)
    <<~COMMANDS
      @#{register}
      #{is_direct ? 'D=A' : 'D=M'}
      #{%W[@#{index} A=D+A D=M].join("\n") if is_offset}
      @SP
      A=M
      M=D
      @SP
      M=M+1
    COMMANDS
  end

  def push_command(segment, index)
    case segment
    when 'argument'
      push_command_template('ARG', index, is_direct: false, is_offset: true)
    when 'local'
      push_command_template('LCL', index, is_direct: false, is_offset: true)
    when 'this'
      push_command_template('THIS', index, is_direct: false, is_offset: true)
    when 'that'
      push_command_template('THAT', index, is_direct: false, is_offset: true)
    when 'static'
      push_command_template(16 + index, 0, is_direct: false, is_offset: false)
    when 'constant'
      push_command_template(index, 0, is_direct: true, is_offset: false)
    when 'pointer'
      push_command_template('R3', index, is_direct: true, is_offset: true)
    when 'temp'
      push_command_template('R5', index, is_direct: true, is_offset: true)
    end
  end

  def pop_command(segment, index)
    case segment
    when 'argument'
      pop_command_template('ARG', index)
    when 'local'
      pop_command_template('LCL', index)
    when 'this'
      pop_command_template('THIS', index)
    when 'that'
      pop_command_template('THAT', index)
    when 'static'
      pop_command_template('16', index, is_direct: true)
    when 'pointer'
      pop_command_template('R3', index, is_direct: true)
    when 'temp'
      pop_command_template('R5', index, is_direct: true)
    end
  end

  def pop_command_template(register, index, is_direct: false)
    <<~COMMANDS
      @#{register}
      #{is_direct ? 'D=A' : 'D=M'}
      @#{index}
      D=D+A
      @R13
      M=D
      @SP
      AM=M-1
      D=M
      @R13
      A=M
      M=D
    COMMANDS
  end
end
