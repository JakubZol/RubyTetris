class Board
  attr_reader :board, :height, :width

  def initialize(width, height)
    @width = width
    @height = height
    @board = []

    0.upto(@width) do |column|
      @board.append([])
      0.upto(@height) { || @board[column].append(0) }
    end
  end

  def draw
    0.upto(@width) do |column|
      0.upto(@height) do |row|
        if @board[column][row] > 0
          Square.new(x: column * GRID_SIZE, y: row * GRID_SIZE, size: GRID_SIZE - 0.5, color: COLORS[@board[column][row] - 1])
        end
      end
    end
  end

  def add_new_shape(shape)
    shape.shape.each do |cell|
      @board[cell[0]][cell[1]] = shape.color + 1
    end
  end

  def is_game_over
    game_over = false

    0.upto(@width) do |column|
      if @board[column][0] > 0
        game_over = true
        break
      end
    end

    game_over
  end

  def update_board(game)
    rows_to_clear = []

    0.upto(@height) do |row|
      occupied_fields_counter = 0

      0.upto(@width) do |column|
        if @board[column][row] > 0
          occupied_fields_counter += 1
        end
      end

      if occupied_fields_counter == @width
        rows_to_clear.append(row)
      end
    end

    rows_to_clear.each do |row_to_clear|
      0.upto(@width) do |column|
        @board[column].delete_at(row_to_clear)
        @board[column].unshift(0)
      end
    end

    game.update_score(rows_to_clear.length)
  end

  def can_shape_move?(shape)
    can_shape_move = true
    shape.each do |cell|
      new_cell = @board[cell[0]][cell[1] + 1]
      if cell[1] + 1 == @height
        can_shape_move = false
        break
      elsif new_cell > 0
        can_shape_move = false
        break
      end
    end

    can_shape_move
  end

end
