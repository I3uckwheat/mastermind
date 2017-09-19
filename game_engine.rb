require 'colorize'
require 'colorized_string'
# 🌑.color for pin
# 🌕 for hole
# ◦ for ans hole
# • for selection
# six colors
# 4 pegs
class GameEngine
  require './mastermind.rb'
  def initialize(number_of_pegs = 4)
    mastermind = Mastermind.new(number_of_pegs)
    @current_round = 0
    round
  end

  def round
    @current_round += 1
    place(recieve_input)
    # place
    # win?
    show_playfield
  end

  def show_playfield
    mastermind.show_board
  end

  private

  def place(player_input)
    mastermind.place(player_input, @current_round)
  end

  def recieve_input
    mastermind.recieve_input
  end

  def win?(player_input)
    mastermind.win_condition(player_input)
  end
end
