require_relative "common"

include Common

def create_board(border, data)
  height = border.max_y + 3
  width = [border.max_x - border.min_x + 1, height * 2].max

  puts border.min_x
  puts border.max_x
  shift = (width - 1) / 2

  board = Array.new(height) { Array.new(width, ".") }
  data.each { |path|
    path.each { |lines|
      lines.each { |idx|
        x, y = idx
        board[y][x - (500 - shift)] = "#"
      }
    }
  }

  board[-1] = Array.new(width, "#")

  board[0][shift] = "+"
  border.min_x = 500 - shift
  border.max_x = 500 + shift
  border.max_y = border.max_y + 2
  return board, shift
end

def simulate_step(board, border, shift)
  y, x = 0, shift

  while true
    if board[y + 1][x] == "."
      y = y + 1
    elsif board[y + 1][x - 1] == "."
      y = y + 1
      x = x - 1
    elsif board[y + 1][x + 1] == "."
      y = y + 1
      x = x + 1
    else
      if y == 0 and x == shift then
        return :stop
      else
        board[y][x] = "o"
        return :ok
      end
    end
  end
end

def main()
  border, data = load_data "data/input.txt"

  board, shift = create_board(border, data)

  i = 0
  while simulate_step(board, border, shift) == :ok
    i = i + 1
  end

  i += 1

  print_board board
  puts i
end

main
