class GameEngine
  def initialize(number_of_pegs = 4)
    require './master_mind.rb'
    @rounds = 10
    @round_number = 0
    @mastermind = Mastermind.new(@rounds, number_of_pegs)
  end

  def player_round
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
      @mastermind.print_lines
      true
    end
  end

  def lose?
    if @round_number == @rounds
      puts 'YOU LOSE'
      @mastermind.print_lines
      true
    end
  end

  private

  def hint
    @mastermind.hint(@round_number)
  end

  def place(player_input)
    @mastermind.place(player_input, @round_number)
  end

  def recieve_input
    @mastermind.recieve_input
  end
end
