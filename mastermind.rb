require './game_engine.rb'
g = GameEngine.new

g.player_round until g.win? || g.lose?
