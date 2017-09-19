require 'colorize'
require 'colorized_string'

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
      puts "#{values[:line_number]}  | #{values[:guess].join(' ')} | #{values[:answer].join} | ".rjust(25)
    end
    puts line
    show_options
  end

  def dot(color)
    ColorizedString['🌑'].colorize(@colors[color])
  end

  def show_options
    puts "#{dot(1)} #{dot(2)} #{dot(3)}"
    puts "#{dot(4)} #{dot(5)} #{dot(6)}"
  end

  def place(player_input, current_round)
    @lines[('line' + current_round.to_s).to_sym] = player_input.map do |color|
      dot(color)
    end
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

  def input_validator(input) # Recieves array and validates it; returns integer array
    if input.length == 4 &&
       input.each { |x| x < 7 } &&
       /\d\d\d\d/.match?(input.join)
      input.map(&:to_i)
    else
      show_board
      puts 'INVALID INPUT'
      puts 'TRY AGAIN'
      get_input
    end
  end
end
