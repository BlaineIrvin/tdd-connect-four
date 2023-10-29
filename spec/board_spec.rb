# frozen_string_literal: true

require_relative '../lib/board.rb'

describe Board do
  subject(:board) { described_class.new }

  describe 'draw_board' do
    it 'returns test' do
      expect(board).to receive(:draw_row).exactly(6).times
      board.draw_board
    end
  end

  describe 'draw_row' do
    it 'draws a blank row' do
      expected_row = '-------'
      expect(board).to receive(:puts).with(expected_row)

      board.draw_row(5)
    end

    it 'draws a row with player 1 pieces' do
      game_board = board.instance_variable_get(:@board)
      game_board[4][3] = 1
      game_board[4][6] = 1

      expected_row = '---x--x'
      expect(board).to receive(:puts).with(expected_row)

      board.draw_row(4)
    end

    it 'draws a row with player 2 pieces' do
      game_board = board.instance_variable_get(:@board)
      game_board[1][1] = 2
      game_board[1][4] = 2

      expected_row = '-o--o--'
      expect(board).to receive(:puts).with(expected_row)

      board.draw_row(1)
    end

    it 'draws a full row with both players' do
      game_board = board.instance_variable_get(:@board)
      game_board[3][0] = 1
      game_board[3][1] = 2
      game_board[3][2] = 1
      game_board[3][3] = 1
      game_board[3][4] = 2
      game_board[3][5] = 1
      game_board[3][6] = 2

      expected_row = 'xoxxoxo'
      expect(board).to receive(:puts).with(expected_row)

      board.draw_row(3)
    end
  end

  describe 'place_piece' do
    it 'adds player 1 piece to a blank board' do
      game_board = board.instance_variable_get(:@board)

      expect(game_board[5][2]).to be_nil

      response = board.place_piece(1, 2)

      expect(response).to be_nil
      expect(game_board[0][2]).to be_nil
      expect(game_board[1][2]).to be_nil
      expect(game_board[2][2]).to be_nil
      expect(game_board[3][2]).to be_nil
      expect(game_board[4][2]).to be_nil
      expect(game_board[5][2]).to eq(1)
    end

    it 'adds player 2 piece to a board in play' do
      game_board = board.instance_variable_get(:@board)
      game_board[5][3] = 1

      expect(game_board[5][3]).to eq(1)
      expect(game_board[5][4]).to be_nil

      response = board.place_piece(2, 4)

      expect(response).to be_nil
      expect(game_board[5][3]).to eq(1)
      expect(game_board[5][4]).to eq(2)
    end

    it 'adds player 2 piece on top of another piece' do
      game_board = board.instance_variable_get(:@board)
      game_board[5][3] = 1

      expect(game_board[5][3]).to eq(1)
      expect(game_board[4][3]).to be_nil

      response = board.place_piece(2, 3)

      expect(response).to be_nil
      expect(game_board[5][3]).to eq(1)
      expect(game_board[4][3]).to eq(2)
    end

    it 'returns a message if column is filled' do
      game_board = board.instance_variable_get(:@board)
      game_board[0][0] = 1
      game_board[1][0] = 2
      game_board[2][0] = 2
      game_board[3][0] = 1
      game_board[4][0] = 1
      game_board[5][0] = 1

      response = board.place_piece(1, 0)

      expect(response).to eq('The selected column is already filled, please choose another.')
    end
  end

  describe 'game_over?' do
    it 'is over with 4 pieces vertically' do
      game_board = board.instance_variable_get(:@board)
      game_board[2][3] = 1
      game_board[3][3] = 1
      game_board[4][3] = 1
      game_board[5][3] = 1

      expect(board).to be_game_over
    end

    it 'is over with 4 pieces horizontally' do
      game_board = board.instance_variable_get(:@board)
      game_board[5][6] = 1
      game_board[5][5] = 1
      game_board[5][4] = 1
      game_board[5][3] = 1

      expect(board).to be_game_over
    end

    it 'is over with 4 pieces diagonally left' do
      game_board = board.instance_variable_get(:@board)
      game_board[2][0] = 1
      game_board[3][1] = 1
      game_board[4][2] = 1
      game_board[5][3] = 1

      expect(board).to be_game_over
    end

    it 'is over with 4 pieces diagonally right' do
      game_board = board.instance_variable_get(:@board)
      game_board[2][6] = 1
      game_board[3][5] = 1
      game_board[4][4] = 1
      game_board[5][3] = 1

      expect(board).to be_game_over
    end

    it 'is not over without 4 pieces in a row' do
      game_board = board.instance_variable_get(:@board)
      game_board[3][3] = 1
      game_board[4][3] = 1
      game_board[5][3] = 1

      game_board[5][5] = 1
      game_board[5][4] = 1

      game_board[3][5] = 1
      game_board[4][4] = 1

      expect(board).to_not be_game_over
    end

    it 'is not over with a filled board' do
      game_board = board.instance_variable_get(:@board)
      game_board[0][0] = 1
      game_board[0][1] = 2
      game_board[0][2] = 2
      game_board[0][3] = 2
      game_board[0][4] = 1
      game_board[0][5] = 2
      game_board[0][6] = 2

      game_board[1][0] = 1
      game_board[1][1] = 2
      game_board[1][2] = 1
      game_board[1][3] = 1
      game_board[1][4] = 2
      game_board[1][5] = 1
      game_board[1][6] = 1

      game_board[2][0] = 2
      game_board[2][1] = 1
      game_board[2][2] = 2
      game_board[2][3] = 1
      game_board[2][4] = 2
      game_board[2][5] = 2
      game_board[2][6] = 2

      game_board[3][0] = 1
      game_board[3][1] = 1
      game_board[3][2] = 2
      game_board[3][3] = 2
      game_board[3][4] = 1
      game_board[3][5] = 1
      game_board[3][6] = 1

      game_board[4][0] = 2
      game_board[4][1] = 2
      game_board[4][2] = 2
      game_board[4][3] = 1
      game_board[4][4] = 1
      game_board[4][5] = 2
      game_board[4][6] = 2

      game_board[5][0] = 1
      game_board[5][1] = 1
      game_board[5][2] = 1
      game_board[5][3] = 2
      game_board[5][4] = 2
      game_board[5][5] = 2
      game_board[5][6] = 1

      expect(board).to_not be_game_over
    end
  end
end