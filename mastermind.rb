require 'colorize'
# 🌑.color for pin
# 🌕 for hole
# six colors
# 4 pegs
class GameEngine
  def initialize(number_of_pegs = 4)
    mastermind = Mastermind.new(number_of_pegs)
    round
  end

  def round
    recieve_input
    # place
    # win?
    # show_playfield
  end

  def show_playfield
    mastermind.show_board
  end

  private

  def win?(player_input)
    mastermind.win_condition(player_input)
  end

  def place(player_input)
    mastermind.place(player_input)
  end

  def recieve_input
    mastermind.input
  end

  class Mastermind
    def initialize(number_of_pegs)
      @code = generate_code(number_of_pegs)
      puts 'Welcome to MASTERMIND!'
      show_board
    end

    def show_board
      puts '------------------------'
      puts 'Board here'
      puts '------------------------'
      show_colors
    end

    def show_colors
      puts 'Shows 0..5 colors to select from with corrisponding numbers'
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

    def input
      puts "Enter #{@code.length} numbers corrisponding to the colors above"
      player_code = gets.chomp.split('')
      player_code.delete(' ')
      input_validator(input)
    end

    private

    def input_validator(input)
      if input.length == 4 && /\d\d\d\d/.match?(input.join)
        input.map(&:to_i)
      else
        puts 'INVALID INPUT'
        puts 'TRY AGAIN'
        #     show_board
        #     get input again
      end
    end
  end
end
