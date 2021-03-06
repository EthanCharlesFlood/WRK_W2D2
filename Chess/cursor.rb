require "io/console"
require_relative "board.rb"

KEYMAP = {
  " " => :space,
  "h" => :left,
  "j" => :down,
  "k" => :up,
  "l" => :right,
  "w" => :up,
  "a" => :left,
  "s" => :down,
  "d" => :right,
  "\t" => :tab,
  "\r" => :return,
  "\n" => :newline,
  "\e" => :escape,
  "\e[A" => :up,
  "\e[B" => :down,
  "\e[C" => :right,
  "\e[D" => :left,
  "\177" => :backspace,
  "\004" => :delete,
  "\u0003" => :ctrl_c,
}

MOVES = {
  left: [0, -1],
  right: [0, 1],
  up: [-1, 0],
  down: [1, 0]
}

class Cursor

  attr_reader :board
  attr_accessor :cursor_pos

  def initialize(cursor_pos, board)
    @cursor_pos = cursor_pos
    @board = board
    @selected = false
  end

  def get_input
    key = KEYMAP[read_char]
    handle_key(key)
  end

  private

  def read_char
    STDIN.echo = false

    STDIN.raw!

    input = STDIN.getc.chr

    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil

      input << STDIN.read_nonblock(2) rescue nil
    end

    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  def handle_key(key)
    case key
    when :space, :return 
      return self.cursor_pos
    when :up, :down, :right, :left
      update_pos(MOVES[key])
      return nil
    when :ctrl_c
      Process.exit(0)
    end
  end

  def update_pos(diff)
    row, col = self.cursor_pos
    rowd, cold = diff
    old_pos = [row,col]
    new_pos = [row+rowd, col+cold]

    if self.board.valid_pos?(new_pos) == true
      self.cursor_pos = new_pos
    else
      self.cursor_pos == old_pos
    end
  end

  def toggle_selected

  end
end

class NotValidPosError < StandardError
  def message
    "Not a valid position"
  end
end
