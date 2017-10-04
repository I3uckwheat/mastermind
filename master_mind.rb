require 'colorized_string'

class Mastermind
  def initialize(number_of_rounds, number_of_pegs = 4)
    @code = generate_code(number_of_pegs)
    @lines = generate_hash(number_of_rounds)
    @last_input = nil
    @colors = { 1 => 'magenta', 2 => 'light_red', 3 => 'green',
                4 => 'yellow', 5 => 'cyan', 6 => 'white', 7 => 'light_black' }
    puts 'Welcome to MASTERMIND!'
    show_board
  end

  def generate_hash(number_of_rounds)
    hash = {}
    number_of_rounds.times do |x|
      hash[('line' + x.to_s).to_sym] = { line_number: x + 1,
                                         guess: Array.new(4, ColorizedString['🌕'].colorize(:white)),
                                         hint: Array.new(4, ColorizedString['◦'].colorize(:white)) }
    end
    hash
  end

  def show_board
    line = '------------------'.rjust(24)
    puts line
    puts '|   MASTERMIND   |'.rjust(24)
    puts line
    @lines.each_value do |values|
      puts "#{values[:line_number]}  | #{values[:guess].join(' ')} | #{values[:hint].join} | ".rjust(137)
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

  def win_condition
    @last_input == @code
  end

  def recieve_input
    puts "Enter #{@code.length} numbers corrisponding to the colors above"
    player_code = gets.chomp.split('')
    player_code.delete(' ')
    input_validator(player_code)
  end

  def place(player_input, round_number) # Where player input is an array
    @lines[('line' + round_number.to_s).to_sym][:guess] = player_input.map { |color| dot(color) }
  end

  def hint(line_number)
    guess = @last_input.clone
    secret = @code.clone
    matches, partials = matcher(guess, secret)
    hints = Array.new(matches, ColorizedString['•'].colorize(:red))
    partials.times { hints << ColorizedString['•'].colorize(:white) }
    update_board(hints, line_number)
  end

  def print_lines
    puts @code
  end

  private

  def matcher(guess, secret)
    matches, to_delete = exact_matches(guess, secret)
    guess, secret = delete_from_same_indexes(guess, secret, to_delete)
    partials = partial_matches(guess, secret)
    [matches, partials]
  end

  def exact_matches(guess, secret) # where guess, secret is an array
    match_arry = []
    secret.each_with_index do |number, index|
      match_arry << index if exact_match?(number, guess[index])
    end
    p match_arry
    [match_arry.length, match_arry]
  end

  def delete_from_same_indexes(guess, secret, to_delete)
    to_delete.reverse_each do |match|
      secret.delete_at(match)
      guess.delete_at(match)
    end
    [guess, secret]
  end

  def partial_matches(guess, secret) # where guess, secret is an array
    partials = 0
    guess.each_with_index do |number, _index|
      if secret.include?(number)
        secret.delete_at(secret.find_index(number))
        partials += 1
      end
    end
    partials
  end

  def exact_match?(guess, secret)
    guess == secret
  end

  def input_validator(input)
    if valid_input?(input)
      @last_input = input.map(&:to_i)
    else
      invalid_message
    end
  end

  def valid_input?(input)
    input.length == 4 &&
      input.all? { |x| x.to_i.between?(1, 6) } &&
      /\d\d\d\d/.match?(input.join)
  end

  def invalid_message
    show_board
    puts 'INVALID INPUT'
    puts 'TRY AGAIN'
    recieve_input
  end

  def update_board(hints, line)
    hints.each_with_index do |hint, index|
      @lines[('line' + line.to_s).to_sym][:hint][index] = hint
    end
  end
end
