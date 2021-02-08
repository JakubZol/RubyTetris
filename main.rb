require 'ruby2d'
require './classes/game.rb'
require './classes/board.rb'
require './classes/shape.rb'

INITIAL_FPS = 3

set background: 'black'
set width: 400
set height: 800
set fps_cap: INITIAL_FPS
set title: 'Tetris'

GRID_SIZE = 40
GRID_WIDTH = Window.width / GRID_SIZE
GRID_HEIGHT = Window.height / GRID_SIZE

O_BLOCK = [[4, 0], [5, 0], [4, 1], [5, 1]]
I_BLOCK = [[4, 0], [4, 1], [4, 2], [4, 3]]
J_BLOCK = [[4, 0], [4, 1], [5, 1], [6, 1]]
L_BLOCK = [[4, 0], [5, 0], [6, 0], [4, 1]]
S_BLOCK = [[4, 0], [4, 1], [5, 1], [5, 2]]
T_BLOCK = [[5, 0], [4, 1], [5, 1], [5, 2]]
Z_BLOCK = [[4, 0], [5, 0], [5, 1], [6, 1]]
COLORS = %w[red yellow blue green purple brown]

figures = [O_BLOCK, I_BLOCK, J_BLOCK, L_BLOCK, S_BLOCK, T_BLOCK, Z_BLOCK]
shape = Shape.new(figures.sample)
board = Board.new(GRID_WIDTH, GRID_HEIGHT)
game = Game.new
music = Music.new('./resources/tetris.mp3')
music.loop = true
# music.play

update do
  clear
  if game.game_over
    music.stop
    Text.new("GAME OVER!", color: 'red', x: 10, y: 10, size: 25)
    Text.new("YOUR SCORE: #{game.score}", color: 'red', x: 10, y: 40, size: 25)
    Text.new("PRESS 'R' TO RESTART", color: 'red', x: 10, y: 70, size: 25)
    Text.new("PRESS 'Q' TO QUIT", color: 'red', x: 10, y: 100, size: 25)
  else
    Text.new("SCORE: #{game.score}", color: 'white', x: 10, y: 10, size: 15)
    Text.new("LEVEL: #{game.level}", color: 'white', x: 10, y: 26, size: 15)
    Text.new("ROWS CLEARED: #{game.rows_cleared}", color: 'white', x: 10, y: 42, size: 15)
    Text.new("HIGH SCORE: #{game.high_score}", color: 'white', x: 10, y: 58, size: 15)
    board.draw
    shape.draw
    unless game.paused
      if board.can_shape_move?(shape.shape)
        shape.move_down
      else
        board.add_new_shape(shape)
        shape = Shape.new(figures.sample)
      end

      level = game.level
      board.update_board(game)
      new_level = game.level
      if new_level > level
        set fps_cap: Window.fps_cap + 0.5 * (new_level - level)
      end

      game.game_over = board.is_game_over
    end
  end
end

on :key_down do |event|
  if event.key == 'left' and !game.paused
    shape.move_sideways(-1, board)
  elsif event.key == 'right' and !game.paused
    shape.move_sideways(1, board)
  elsif event.key == 'down' and !game.paused
    if board.can_shape_move?(shape.shape)
      shape.move_down
    end
  elsif event.key == 'q' or event.key == 'Q'
    exit
  elsif (event.key == 'r' or event.key == 'R') and game.game_over
    shape = Shape.new(figures.sample)
    board = Board.new(GRID_WIDTH, GRID_HEIGHT)
    game = Game.new
    set fps_cap: INITIAL_FPS
    # music.play
  elsif event.key == 'space' and !game.paused
    shape.rotate_shape(board)
  elsif event.key == 'p' or event.key == 'P'
    if game.paused
      music.resume
    else
      music.pause
    end
    game.paused = !game.paused
  end

end

show
