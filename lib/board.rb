# frozen_string_literal: true

class Board
  def initialize(rows = 6, cols = 7)
    @board = Array.new(rows) { Array.new(cols) }
  end

  def draw_board
    @board.length.times do |row_num|
      draw_row(row_num)
    end
  end

  def draw_row(row_num)
    row = ''
    @board[row_num].each do |piece|
      if piece == 1
        row = row + 'x'
      elsif piece == 2
        row = row + 'o'
      else
        row = row + '-'
      end
    end

    puts row
  end

  def place_piece(player, col_num)
    bottom_row = @board.length
    success = false

    (0...bottom_row).each do |row_num|
      if piece_placeable?(row_num, col_num)
        @board[row_num][col_num] = player
        success = true
        break
      end
    end

    success ? nil : 'The selected column is already filled, please choose another.'
  end

  def game_over?
    four_in_rows? || four_in_cols? || four_in_diagonals?
  end

  private

  def piece_placeable?(row_num, col_num)
    @board[row_num][col_num] == nil && (bottom_row?(row_num) || piece_under?(row_num, col_num))
  end

  def piece_under?(row_num, col_num)
    @board[row_num + 1][col_num] != nil
  end

  def bottom_row?(row_num)
    row_num == @board.length - 1
  end

  def four_in_rows?
    (0...@board.length).each do |row_num|
      in_a_row = 0
      last_piece = @board[row_num][0]
      @board[row_num].each do |col|
        this_piece = col
        if this_piece == last_piece
          in_a_row += 1
          if in_a_row >= 4 && this_piece != nil
            return true
          end
        else
          last_piece = this_piece
          in_a_row = 1
        end
      end
    end
    return false
  end

  def four_in_cols?
    (0...@board[0].length).each do |col_num|
      in_a_row = 0
      last_piece = @board[0][col_num]
      @board.each do |row|
        this_piece = row[col_num]
        if this_piece == last_piece
          in_a_row += 1
          if in_a_row >= 4 && this_piece != nil
            return true
          end
        else
          last_piece = this_piece
          in_a_row = 1
        end
      end
    end
    return false
  end

  def four_in_diagonals?
    row_length = @board.length
    col_length = @board[0].length

    (0...row_length).each do |row_num|
      in_a_row = 0
      last_piece = @board[row_num][0]
      offset = 0

      while row_num + offset < row_length do
        this_piece = @board[row_num + offset][offset]
        if this_piece == last_piece
          in_a_row += 1
          if in_a_row >= 4 && this_piece != nil
            return true
          end
        else
          last_piece = this_piece
          in_a_row = 1
        end
        offset += 1
      end
    end

    (0...col_length).each do |col_num|
      in_a_row = 0
      last_piece = @board[0][col_num]
      offset = 0

      while col_num + offset < row_length do
        this_piece = @board[offset][col_num + offset]
        if this_piece == last_piece
          in_a_row += 1
          if in_a_row >= 4 && this_piece != nil
            return true
          end
        else
          last_piece = this_piece
          in_a_row = 1
        end
        offset += 1
      end
    end

    (0...row_length).each do |row_num|
      in_a_row = 0
      last_piece = @board[row_num][0]
      offset = 0

      while row_num - offset >= 0 do
        this_piece = @board[row_num - offset][offset]
        if this_piece == last_piece
          in_a_row += 1
          if in_a_row >= 4 && this_piece != nil
            return true
          end
        else
          last_piece = this_piece
          in_a_row = 1
        end
        offset += 1
      end
    end

    (0...col_length).each do |col_num|
      in_a_row = 0
      last_piece = @board[row_length - 1][col_num]
      offset = col_length - 1 - col_num

      while offset > 0 do
        this_piece = @board[row_length - offset][col_num + offset]
        if this_piece == last_piece
          in_a_row += 1
          if in_a_row >= 4 && this_piece != nil
            return true
          end
        else
          last_piece = this_piece
          in_a_row = 1
        end
        offset -= 1
      end
    end
    return false
  end
end