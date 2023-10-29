# frozen_string_literal: true

require_relative '../lib/main_game.rb'

describe MainGame do
  let(:board) { double('board', game_over?: false) }
  subject(:game) { described_class.new(board) }

  before do
    allow(game).to receive(:puts)
  end

  describe 'main_loop' do
    describe 'when player 1 input returns a column' do
      before do
        game.instance_variable_set(:@player_turn, 1)
        allow(game).to receive(:player_input).and_return(2)
        allow(board).to receive(:draw_board)
        allow(board).to receive(:place_piece)
        allow(board).to receive(:game_over?).and_return(true)
      end

      it 'places a player 1 piece in that column' do
        expect(board).to receive(:place_piece).with(1, 2)
        game.main_loop
      end
    end

    describe 'when player 1 input returns a column' do
      before do
        game.instance_variable_set(:@player_turn, 2)
        allow(game).to receive(:player_input).and_return(5)
        allow(board).to receive(:draw_board)
        allow(board).to receive(:place_piece)
        allow(board).to receive(:game_over?).and_return(true)
      end

      it 'places a player 1 piece in that column' do
        expect(board).to receive(:place_piece).with(2, 5)
        game.main_loop
      end
    end

    describe 'when the selected column is full' do
      before do
        game.instance_variable_set(:@player_turn, 2)
        allow(game).to receive(:player_input).and_return(4)
        allow(board).to receive(:draw_board)
        allow(board).to receive(:place_piece).and_return('Error string', nil)
        allow(board).to receive(:game_over?).and_return(true)
      end

      it 'does not continue the turn and displays an error' do
        expect(game).to receive(:puts).with('Error string').once
        game.main_loop
        player = game.instance_variable_get(:@player_turn)
        expect(player).to eq(2)
      end
    end

    describe 'when the game is over' do
      before do
        game.instance_variable_set(:@player_turn, 2)
        allow(game).to receive(:player_input).and_return(1)
        allow(board).to receive(:draw_board)
        allow(board).to receive(:place_piece)
        allow(board).to receive(:game_over?).and_return(true)
      end

      it 'displays a congratulation' do
        player = game.instance_variable_get(:@player_turn)
        expect(player).to eq(2)
        expect(game).to receive(:puts).with('Congratulations! Player 2 wins!').once
        game.main_loop
      end
    end
  end

  describe 'player_input' do
    describe 'when player input is requested' do
      before do
        allow(game).to receive(:gets).and_return('4')
      end

      it 'displays the current player and input instruction' do
        expect(game).to receive(:puts).with('Player 1, select a column(1-7)').once
        game.player_input
      end
    end

    describe 'when a column of 4 is entered' do
      before do
        allow(game).to receive(:gets).and_return('4')
      end

      it 'returns user input as column index 3' do
        result = game.player_input
        expect(result).to eql(3)
      end
    end

    describe 'when an invalid column is entered, follow by a valid column' do
      before do
        allow(game).to receive(:gets).and_return('8', '4')
      end

      it 'completes the loop and displays the error message' do
        expect(game).to receive(:puts).with('Player 1, select a column(1-7)').once
        expect(game).to receive(:puts).with('Please enter a number between 1 and 7').once
        game.player_input
      end
    end

    describe 'when an invalid column is entered twice, follow by a valid column' do
      before do
        allow(game).to receive(:gets).and_return('8', '0', '4')
      end

      it 'completes the loop and displays the error message' do
        expect(game).to receive(:puts).with('Player 1, select a column(1-7)').once
        expect(game).to receive(:puts).with('Please enter a number between 1 and 7').twice
        game.player_input
      end
    end

    describe 'when a non-number input is entered, followed by a valid column' do
      before do
        allow(game).to receive(:gets).and_return('t', '4')
      end

      it 'completes the loop and displays the error message' do
        expect(game).to receive(:puts).with('Player 1, select a column(1-7)').once
        expect(game).to receive(:puts).with('Please enter a number between 1 and 7').once
        game.player_input
      end
    end
  end

  describe 'change_player' do
    describe 'when current player is 1' do
      before do
        game.instance_variable_set(:@player_turn, 1)
      end

      it 'changes current player to 2' do
        game.change_player
        result = game.instance_variable_get(:@player_turn)
        expect(result).to eq(2)
      end
    end

    describe 'when current player is 2' do
      before do
        game.instance_variable_set(:@player_turn, 2)
      end

      it 'changes current player to 1' do
        game.change_player
        result = game.instance_variable_get(:@player_turn)
        expect(result).to eq(1)
      end
    end
  end
end