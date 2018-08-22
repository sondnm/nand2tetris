# frozen_string_literal: true
require_relative "./parser"
require_relative "./code"
require_relative "./symbol_table"

class Assembler
  def initialize(input_file)
    @input_file = input_file
    @output_file = get_output_file
    @symbol_table = SymbolTable.new
    @symbol_address = 16
    @code = Code.new
  end

  def assemble
    first_pass
    second_pass
  end

  def first_pass
    parser = Parser.new(@input_file)
    current_address = 0
    loop do
      parser.advance
      symbol = parser.symbol
      if parser.command_type == Parser::L_COMMAND
        raise "Duplicated symbol: #{symbol}" if @symbol_table.contains?(symbol)
        @symbol_table.add_entry(symbol, current_address)
      else
        current_address += 1
      end
      break unless parser.has_more_commands?
    end
  end

  def second_pass
    output_file = File.open(@output_file, "wb+")
    parser = Parser.new(@input_file)
    loop do
      parser.advance
      out_stream =
        case parser.command_type
        when Parser::A_COMMAND
          get_a_address(parser.symbol)
        when Parser::C_COMMAND
          @code.get_c_code(
            @code.comp(parser.comp),
            @code.dest(parser.dest),
            @code.jump(parser.jump)
          )
        end
      output_file.puts(out_stream) if out_stream
      break unless parser.has_more_commands?
    end
  end

  private

  def get_output_file
    raise "Input file #{@input_file} must have .asm extension" if File.extname(@input_file) != ".asm"
    "#{File.dirname(@input_file)}/#{File.basename(@input_file, '.*')}.hack"
  end

  def get_a_address(symbol)
    return @code.get_a_code(symbol) if symbol.match?(/^\d+$/)
    unless @symbol_table.contains?(symbol)
      @symbol_table.add_entry(symbol, @symbol_address)
      @symbol_address += 1
    end
    @code.get_a_code(@symbol_table.get_address(symbol))
  end
end
