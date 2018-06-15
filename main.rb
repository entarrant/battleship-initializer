#!/usr/bin/env ruby

# -----------------------------------
# |            Ship class           |
# -----------------------------------
class Ship
  attr_accessor :letter, :size

  def initialize(options={})
    @letter = options[:letter]
    @size = options[:size]
  end
end

# -----------------------------------
# |         Helper methods          |
# -----------------------------------

TOTAL_SQUARES = 100.freeze
DIRECTION_GUESSES = 4.freeze

LEFT = 0.freeze
RIGHT = 1.freeze
UP = 2.freeze
DOWN = 3.freeze

def create_board
  board_array = []
  10.times do
    board_array << %w(. . . . . . . . . .)
  end

  board_array
end

def create_ships
  @tug = Ship.new(letter: 'T', size: 2)
  @destroyer = Ship.new(letter: 'D', size: 3)
  @submarine = Ship.new(letter: 'S', size: 3)
  @battleship = Ship.new(letter: 'B', size: 4)
  @cruiser = Ship.new(letter: 'C', size: 5)
end

def coordinates_in_direction(x_coor, y_coor, direction)
  pair = case direction
  when LEFT
    [y_coor, x_coor - 1]
  when RIGHT
    [y_coor, x_coor + 1]
  when UP
    [y_coor + 1, x_coor]
  when DOWN
    [y_coor - 1, x_coor]
  else
    raise 'A direction was not passed'
  end
  pair
end

def write_ship_placement(ship, x_coor, y_coor, direction)
  curr_x = x_coor
  curr_y = y_coor


  ship.size.times do
    @board_array[curr_y][curr_x] = ship.letter

    case direction
    when LEFT
      curr_x -= 1
    when RIGHT
      curr_x += 1
    when UP
      curr_y += 1
    when DOWN
      curr_y -= 1
    else
      raise 'A direction was not passed'
    end

  end
end

def attempt_ship_placement(ship)
  attempted_squares = create_board
  squares_left_to_guess = TOTAL_SQUARES

  success = false

  loop do
    if squares_left_to_guess <= 0
      raise "There were not #{ship.size} squares available to place #{ship.letter}"
    end

    # Check a random square
    x_coor = rand(10)
    y_coor = rand(10)

    square = attempted_squares[y_coor][x_coor]
    # We already tried this square
    next if square == 'X'

    # Mark square as seen
    attempted_squares[y_coor][x_coor] = 'X'
    squares_left_to_guess -= 1

    # Square is already taken on main board
    next if @board_array[y_coor][x_coor] != '.'

    # Square is available
    # Check for valid placements in cardinal directions
    attempted_directions = %w(. . . .)
    directions_left_to_guess = DIRECTION_GUESSES
    loop do
      # This square is available but there are no valid placements around it
      break if directions_left_to_guess <= 0

      # Get a direction
      dir_num = rand(4)
      direction = attempted_directions[dir_num]

      # We already checked in this direction
      next if direction == 'X'

      # Direction has not yet been checked
      # Check for valid placement in that direction
      curr_x = x_coor
      curr_y = y_coor

      (1..ship.size - 1).each do |idx|
        next_coors = coordinates_in_direction(curr_x, curr_y, dir_num)
        curr_y = next_coors[0]
        curr_x = next_coors[1]

        # Moving in this direction goes off the board
        # Need to pick new direction
        if curr_x < 0 || curr_x > 9 || curr_y < 0 || curr_y > 9
          attempted_directions[dir_num] = 'X'
          directions_left_to_guess -= 1
          break
        end

        next_square = attempted_squares[curr_y][curr_x]

        # Moving in this direction hits a square that's already been seen
        # Need to pick new direction
        if next_square.nil? || next_square == 'X'
          attempted_directions[dir_num] = 'X'
          directions_left_to_guess -= 1
          break
        end

        # Square is already taken on main board; need to pick a new direction
        if @board_array[y_coor][x_coor] != '.'
          attempted_directions[dir_num] = 'X'
          directions_left_to_guess -= 1
          break
        end

        # Square is available!

        # Entire ship has been placed
        # Write this placement to the board and finish
        if idx + 1 == ship.size
          write_ship_placement(ship, x_coor, y_coor, dir_num)
          success = true
          break
        end

        # The full ship hasn't been placed
        # Repeat loop and check if next square is valid and available.
      end
    end
    break if success
  end
end

def print_board_state(board)
  board.each { |row| puts row.join(' ') }
end

# -----------------------------------
# |          Begin program          |
# -----------------------------------

@board_array = create_board
create_ships

[@cruiser, @battleship, @submarine, @destroyer, @tug]. each do |ship|
  attempt_ship_placement(ship)
end

print_board_state(@board_array)
