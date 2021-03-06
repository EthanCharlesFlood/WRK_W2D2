require_relative "board.rb"
require_relative "cursor.rb"
# require "colorize"

class Display

  attr_reader :board, :cursor, :notifications


  def initialize(board)
    @cursor = Cursor.new([0,0],board)
    @board = board
    @notifications = {}
  end

  def render
    system("clear")
    display_grid = Array.new(8) {Array.new(8)}

    (0..7).each do |i|
      (0..7).each do |j|
        pos = [i, j]
        display_grid[i][j] = board[pos].to_s

        if pos == @cursor.cursor_pos && board[pos].to_s != " "
          display_grid[i][j] = board[pos].to_s.colorize(:red)
        elsif pos == @cursor.cursor_pos && board[pos].to_s == " "
          display_grid[i][j] = "x".colorize(:red)
        end
      end
    end
    puts "  A B C D E F G H "
    puts " -----------------"
    display_grid.each_with_index do |row,i|
      puts "#{8 - i}|" + row.join("|") + "|"
    end
    puts " -----------------"

    @notifications.values.each do |value|
      puts value
    end
    nil
  end

  def reset!
    @notifications.delete(:error)
  end

  def check!
    @notifications[:check] = "Check!"
  end

  def uncheck!
    @notifications.delete(:check)
  end

  def move_cursor
    start_pos, end_pos = @cursor.cursor_pos,
    i=0
    while i < 1
      self.cursor.get_input
      system("clear")
      self.render
    end
  end



end
