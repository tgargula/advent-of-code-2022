require_relative "common"

include Common

def create_board(border, data)
  board = Array.new(border.max_y - border.min_y + 1) { Array.new(border.max_x - border.min_x + 1, ".") }
  data.each { |path|
    path.each { |lines|
      lines.each { |idx|
        x, y = idx
        board[y - border.min_y][x - border.min_x] = "#"
      }
    }
  }

  board[0][500 - border.min_x] = "+"
  return board
end

def simulate_step(board, border)
  y, x = 0, 500 - border.min_x

  while true
    if x < 0 or x > border.max_x - border.min_x or y >= border.max_y
      return :stop
    end
    if board[y + 1][x] == "."
      y = y + 1
    elsif board[y + 1][x - 1] == "."
      y = y + 1
      x = x - 1
    elsif board[y + 1][x + 1] == "."
      y = y + 1
      x = x + 1
    else
      board[y][x] = "o"
      return :ok
    end
  end
end

def main()
  border, data = load_data "data/input.txt"

  board = create_board(border, data)
  
  i = 0
  while simulate_step(board, border) == :ok
    i = i + 1
  end
  
  print_board board
  puts i
end

main
