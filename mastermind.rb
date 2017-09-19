require 'colorize'
require 'colorized_string'
# 🌑.color for pin
# 🌕 for hole
# ◦ for ans hole
# • for selection
# six colors
# 4 pegs
class GameEngine
  def initialize(number_of_pegs = 4)
    @mastermind = Mastermind.new(number_of_pegs)
    @round_number = 0
    round
  end

  def round
    @mastermind.debug_show_code
    place(recieve_input)
    hint
    show_playfield
    @round_number += 1
  end

  def show_playfield
    @mastermind.show_board
  end

  def win?
    if @mastermind.win_condition
      puts "You've Won!"
      true
    end
  end

  private

  def hint
    @mastermind.hint
  end

  def place(player_input)
    @mastermind.place(player_input, @round_number)
  end

  def recieve_input
    @mastermind.recieve_input
  end

  class Mastermind
    def initialize(number_of_pegs = 4)
      @code = generate_code(number_of_pegs)
      @lines = generate_hash
      @last_input = nil
      @colors = { 1 => 'magenta', 2 => 'light_red', 3 => 'green',
                  4 => 'yellow', 5 => 'cyan', 6 => 'white', 7 => 'light_black' }
      puts 'Welcome to MASTERMIND!'
      show_board
    end

    def debug_show_code
      p @code
    end

    def generate_hash
      hash = {}
      10.times do |x|
        hash[('line' + x.to_s).to_sym] = { line_number: x + 1,
                                           guess: Array.new(4, ColorizedString['🌕'].colorize(:white)),
                                           answer: %w[◦ ◦ ◦ ◦] }
      end
      hash
    end

    def show_board
      line = '------------------'.rjust(24)
      puts line
      puts '|   MASTERMIND   |'.rjust(24)
      puts line
      @lines.each_value do |values|
        puts "#{values[:line_number]}  | #{values[:guess].join(' ')} | #{values[:answer].join} | ".rjust(81)
      end
      puts line
      show_options
    end

    def dot(color)
      ColorizedString['🌑'].colorize(@colors[color].to_sym)
    end

    def show_options
      puts "#{dot(1)} #{dot(2)} #{dot(3)}"
      puts "#{dot(4)} #{dot(5)} #{dot(6)}"
    end

    def generate_code(pegs) # Chance to add difficulty later
      code = []
      pegs.times { code << rand(6) + 1 }
      code
    end

    def win_condition # last code entered == the computer code = win!
      @last_input == @code
    end

    def recieve_input
      puts "Enter #{@code.length} numbers corrisponding to the colors above"
      player_code = gets.chomp.split('')
      player_code.delete(' ')
      input_validator(player_code)
    end

    def place(player_input, round_number) # Where player input is an array
      @lines[('line' + round_number.to_s).to_sym][:guess] = player_input.map do |color|
        dot(color)
      end
    end

    def hint
      puts 'gives hint'
    end

    private

    def input_validator(input)
      if input.length == 4 &&
         input.all? { |x| x.to_i.between?(1, 6) } &&
         /\d\d\d\d/.match?(input.join)
        @last_input = input.map(&:to_i)
      else
        show_board
        puts 'INVALID INPUT'
        puts 'TRY AGAIN'
        recieve_input
      end
    end
  end
end

g = GameEngine.new

g.round until g.win?
