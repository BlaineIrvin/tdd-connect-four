# frozen_string_literal: true

require_relative '../lib/board.rb'

class MainGame

  def initialize(game_board = Board.new)
    @board = game_board
    @player_turn = 1
  end

  def main_loop
    loop do
      @board.draw_board
      loop do
        col = player_input
        error = @board.place_piece(@player_turn, col)
        break if error == nil
        puts error
      end
      if @board.game_over?
        puts "Congratulations! Player #{@player_turn} wins!"
        return
      end
      change_player
    end
  end

  def player_input
    puts "Player #{@player_turn}, select a column(1-7)"
    loop do
      string_select = gets
      col_select = string_select.to_i - 1
      if col_select >= 0 && col_select <= 6
        return col_select
      end
      puts 'Please enter a number between 1 and 7'
    end
  end

  def change_player
    if @player_turn == 1
      @player_turn = 2
    else
      @player_turn = 1
    end
  end
end