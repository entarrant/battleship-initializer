#!/usr/bin/env ruby

class Ship
  attr_accessor :letter, :size

  def initialize(options={})
    @letter = options[:letter]
    @size = options[:size]
  end
end


board_array = []
10.times do
  board_array << %w(. . . . . . . . . .)
end

tug = Ship.new(letter: 'T', size: 2)
destroyer = Ship.new(letter: 'D', size: 3)
submarine = Ship.new(letter: 'S', size: 3)
battleship = Ship.new(letter: 'B', size: 4)
cruiser = Ship.new(letter: 'C', size: 5)

[cruiser, battleship, submarine, destroyer, tug]. each do |ship|
end
