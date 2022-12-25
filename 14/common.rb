module Common
  Border = Struct.new(:min_x, :min_y, :max_x, :max_y)

  def create_range(a, b)
    if a[0] == b[0] and b[1] > a[1]
      return (a[1]..b[1]).to_a.map { |val| [a[0], val] }
    elsif a[0] == b[0] and b[1] < a[1]
      return (b[1]..a[1]).to_a.map { |val| [a[0], val] }
    elsif a[1] == b[1] and a[0] < b[0]
      return (a[0]..b[0]).to_a.map { |val| [val, a[1]] }
    elsif a[1] == b[1] and a[0] > b[0]
      return (b[0]..a[0]).to_a.map { |val| [val, a[1]] }
    else
      return a
    end
  end

  def load_data(filename)
    file = File.open filename
  
    data = file.readlines.map(&:chomp)
  
    file.close
  
    data = data.map { |path|
      path.split(" -> ").map { |chords|
        chords.split(",").map(&:to_i)
      }
    }
  
    flattened = data.flatten
    even = flattened.each_index.select(&:even?)
    odd = flattened.each_index.select(&:odd?)
  
    border = Border.new
    border.min_x = flattened.values_at(*even).min
    border.min_y = 0
    border.max_x = flattened.values_at(*even).max
    border.max_y = flattened.values_at(*odd).max
  
    data = data.map { |path|
      path.map.with_index { |current, idx|
        idx == 0 ? [current] : create_range(current, path[idx - 1])
      }
    }
  
    return border, data
  end

  def print_board(board)
    board.each { |line|
      puts line.join
    }
  end
end