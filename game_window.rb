require 'gosu'
require_relative 'cell.rb'

class GameWindow < Gosu::Window
  attr_accessor :width, :height, :cells, :time

  def initialize(w, h)
    @width, @height, @time = w, h, 0
    super @width, @height, false

    self.caption = "Game of Life"
    create_cells
  end

  def update
    current_time = Gosu::milliseconds
    if current_time - @time > 500
      @time = current_time
      w, h = @width / 10, @height / 10
      (0...(w)).each do |x|
        (0...(h)).each do |y|
          live_cell_count = 0

          # top left neighbor
          if ((x - 1 > 0) && (y - 1 > 0))
            live_cell_count += 1 if @cells[x-1][y-1].color.eql?(0xffffffff)
          end

          # top neighbor
          if ((x) && (y - 1 > 0))
            live_cell_count += 1 if @cells[x][y-1].color.eql?(0xffffffff)
          end

          # top right neighbor
          if ((x + 1 < w) && (y - 1 > 0))
            live_cell_count += 1 if @cells[x+1][y-1].color.eql?(0xffffffff)
          end

          # right neighbor
          if ((x + 1 < w) && (y))
            live_cell_count += 1 if @cells[x+1][y].color.eql?(0xffffffff)
          end

          # bottom right neighbor
          if ((x + 1 < w) && (y + 1 < h))
            live_cell_count += 1 if @cells[x+1][y+1].color.eql?(0xffffffff)
          end

          # bottom neighbor
          if ((x) && (y + 1 < h))
            live_cell_count += 1 if @cells[x][y+1].color.eql?(0xffffffff)
          end

          # bottom left neighbor
          if ((x - 1 > 0) && (y + 1 < h))
            live_cell_count += 1 if @cells[x-1][y+1].color.eql?(0xffffffff)
          end

          # left neighbor
          if ((x - 1 > 0) && (y))
            live_cell_count += 1 if @cells[x-1][y].color.eql?(0xffffffff)
          end

          # RULES
          # any live cell with less than two live cell neighbors dies
          # any live cell with two or three live neighbors lives
          # any live cell with more than three live neighbors dies
          # any dead cell with three live neighbors lives
          if @cells[x][y].color.eql?(0xffffffff) # living cell
            if live_cell_count < 2
              @cells[x][y].next_color = 0x00000000
            elsif live_cell_count > 3
              @cells[x][y].next_color = 0x00000000
            else
              @cells[x][y].next_color = 0xffffffff
            end
          else # dead cell
            @cells[x][y].next_color = 0xffffffff if live_cell_count.eql? 3
            @cells[x][y].next_color = 0x00000000 if !live_cell_count.eql? 3
          end
        end
      end

      # update each cell at the same time
      (0...(w)).each do |x|
        (0...(h)).each { |y| @cells[x][y].color = @cells[x][y].next_color }
      end
    end
  end

  def draw
    @cells.each do |cell_inner|
      cell_inner.each do |cell|
        draw_quad(cell.coords[0][0], cell.coords[0][1], cell.color,
                  cell.coords[1][0], cell.coords[1][1], cell.color,
                  cell.coords[2][0], cell.coords[2][1], cell.color,
                  cell.coords[3][0], cell.coords[3][1], cell.color)
      end
    end
  end

  protected
  def create_cells
    @cells = []
    (0...(@width/10)).each do |x|
      tmp = []
      (0...(@height/10)).each do |y|
        tmp.push Cell.new(  [[x*10, y*10,],
                                  [(x*10 + 10), (y*10)],
                                  [(x*10), (y*10 + 10)],
                                  [(x*10 + 10), (y*10 + 10)]],
                                  rand(2).eql?(1) ? 0xffffffff : 0x00000000)
      end
      @cells.push(tmp)
    end
  end
end
