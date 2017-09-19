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
    round
  end

  def round
    recieve_input
    # place
    # win?
    # show_playfield
  end

  def show_playfield
    @mastermind.show_board
  end

  private

  def win?(player_input)
    @mastermind.win_condition(player_input)
  end

  def place(player_input)
    @mastermind.place(player_input)
  end

  def recieve_input
    @mastermind.recieve_input
  end

  class Mastermind
    def initialize(number_of_pegs = 4)
      @code = generate_code(number_of_pegs)
      @lines = generate_hash
      @colors = { 1 => 'magenta', 2 => 'light_red', 3 => 'green',
                  4 => 'yellow', 5 => 'cyan', 6 => 'white' }
      puts 'Welcome to MASTERMIND!'
      show_board
    end

    def generate_hash
      hash = {}
      10.times do |x|
        hash[('line' + x.to_s).to_sym] = { line_number: x + 1,
                                           guess: %w[🌕 🌕 🌕 🌕],
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
        puts "#{values[:line_number]}  | #{values[:guess].join(' ')} | \
        #{values[:answer].join} | ".rjust(25)
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

    def update(player_input)
      # where player_input is an array
    end

    def generate_code(pegs) # Chance to add difficulty later
      code = []
      pegs.times { code << rand(7) }
      code
    end

    def win_condition(player_input)
      player_input == @code
    end

    def recieve_input
      puts "Enter #{@code.length} numbers corrisponding to the colors above"
      player_code = gets.chomp.split('')
      player_code.delete(' ')
      input_validator(player_code)
    end

    private

    def input_validator(input)
      if input.length == 4 &&
         input.each { |x| x.to_i < 7 } &&
         /\d\d\d\d/.match?(input.join)
        input.map(&:to_i)
      else
        show_board
        puts 'INVALID INPUT'
        puts 'TRY AGAIN'
        recieve_input
      end
    end
  end
end

game = GameEngine.new
