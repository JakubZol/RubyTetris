def is_square_matrix?(matrix)
  is_square_matrix = true
  matrix_row_count = matrix.length

  0.upto(matrix_row_count - 1) do |row|
    if matrix[row].length != matrix_row_count
      is_square_matrix = false
      break
    end
  end

  is_square_matrix
end

def rotate(matrix)
  if is_square_matrix?(matrix)
    new_matrix = []

    (matrix.length-1).downto(0) { || new_matrix.append([]) }
    (matrix.length-1).downto(0) { |row| 0.upto(matrix[row].length-1) { |column| new_matrix[column].append(matrix[row][column]) }}

    new_matrix
  else
    matrix
  end
end