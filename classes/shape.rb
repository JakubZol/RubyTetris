require './utils/rotate.rb'

class Shape
  attr_reader :shape, :color

  def initialize(shape)
    @shape = shape
    @color = (0...COLORS.length).to_a.sample
  end

  def draw
    @shape.each do |cell|
      Square.new(x: cell[0] * GRID_SIZE, y: cell[1] * GRID_SIZE, size: GRID_SIZE - 0.5, color: COLORS[@color])
    end
  end

  def move_sideways(direction, board)
    new_shape = []
    
    @shape.each do |cell|
      if cell[0] + direction < 0 or cell[0] + direction == board.width or board.board[cell[0] + direction][cell[1]] > 0
        new_shape = @shape
        break
      end
      new_shape.append([cell[0] + direction, cell[1]])
    end

    @shape = new_shape
  end

  def move_down
    new_shape = []
    @shape.each do |cell|
      new_shape.append([cell[0], cell[1] + 1])
    end

    @shape = new_shape
  end

  def rotate_shape(board)
    column_shift = 10
    row_shift = 20
    cols_list = []
    rows_list = []

    @shape.each do |cell|
      column_shift = [cell[0], column_shift].min
      row_shift = [cell[1], row_shift].min

      cols_list.append(cell[0])
      rows_list.append(cell[1])
    end

    matrix_size = [cols_list.uniq.length, rows_list.uniq.length].max
    matrix = []

    0.upto(matrix_size - 1) do |matrix_row|
      matrix.append([])
      0.upto(matrix_size - 1) do |matrix_col|
        if @shape.include?([matrix_col + column_shift, matrix_row + row_shift])
          matrix[matrix_row].append(1)
        else
          matrix[matrix_row].append(0)
        end
      end
    end

    rotated_matrix = rotate(matrix)
    new_shape = []
    0.upto(matrix_size - 1) do |matrix_row|
      0.upto(matrix_size - 1) do |matrix_col|
        if rotated_matrix[matrix_row][matrix_col] == 1
          new_shape.append([matrix_col + column_shift, matrix_row + row_shift])
        end
      end
    end

    is_new_shape_colliding = false
    new_shape.each do |cell|
      if cell[0] >= board.width or cell[1] >= board.height
        is_new_shape_colliding = true
        break
      elsif board.board[cell[0]][cell[1]] > 0
        is_new_shape_colliding = true
        break
      end
    end

    unless is_new_shape_colliding
      @shape = new_shape
    end
  end

end
