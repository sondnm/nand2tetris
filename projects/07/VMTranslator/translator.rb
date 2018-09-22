# frozen_string_literal: true

require_relative './parser'
require_relative './code_writer'

class Translator
  def initialize(infile)
    raise 'File extension must be .vm' if File.extname(infile) != '.vm'

    @infile = infile
    @outfile = get_outfile(infile)
  end

  def translate
    parser = Parser.new(@infile)
    code_writer = CodeWriter.new(@outfile)
    loop do
      break unless parser.has_more_commands?

      parser.advance
      case parser.command_type
      when Parser::C_ARITHMETIC
        code_writer.write_arithmetic(parser.arg1)
      when Parser::C_PUSH, Parser::C_POP
        code_writer.write_push_pop(parser.command_type, parser.arg1, parser.arg2)
      end
    end
    code_writer.close
  end

  private

  def get_outfile(infile)
    "#{File.dirname(infile)}/#{File.basename(infile, '.vm')}.asm"
  end
end
