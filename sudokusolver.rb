#! usr/bin/env ruby

#Sudoku question file
Inputfile=File.new "#{File.dirname(__FILE__)}\\sudoku.txt"

#Sudoku solution file
Solutionfile="#{File.dirname(__FILE__)}\\solution.txt"

def grid_copy(arr)
    arr2=[]
    arr.each { |i| arr2 << i.clone }
    return arr2
end

def solve(grid, y=0, x=0)
    copy_grid=grid_copy(grid)

    y.upto(8) { |i|
        x=0 if i!=y

        x.upto(8) { |j|
            probab=(1 << 10)-2
            probab=check_from_row(probab, copy_grid, i, j)
            probab=check_from_col(probab, copy_grid, i, j)
            probab=check_from_3x3(probab, copy_grid, i, j)
            
            if copy_grid[i][j]==0    
                if probab!=0 && (probab & (probab-1))==0
                    copy_grid[i][j]=(Math.log2(probab).to_i)
                else
                    val=0

                    while probab!=0
                        if (probab & 1)==1
                            copy_grid[i][j]=val
                            solve(copy_grid, i, j+1)
                        end

                        val+=1
                        probab=probab >> 1
                    end

                    return
                end
            end
        }
    }

    print_grid(copy_grid)
    return copy_grid
end

def check_from_row(probab, grid, y, x)
    0.upto(8) { |i|
        probab&=~(1 << grid[y][i]) if i!=x && grid[y][i]!=0
    }

    return probab
end

def check_from_col(probab, grid, y, x)
    0.upto(8) { |i|
        probab&=~(1 << grid[i][x]) if i!=y && grid[i][x]!=0
    }

    return probab
end

def check_from_3x3(probab, grid, y, x)
    x_start=(x/3).floor*3
    y_start=(y/3).floor*3

    y_start.upto(y_start+2) { |i|
        x_start.upto(x_start+2) { |j|
            probab&=~(1 << grid[i][j]) if (i!=y || j!=x) && grid[i][j]!=0
        }
    }

    return probab
end

def init_grid
    grid=Array.new(9)
    file=Inputfile

    0.upto(8) { |i|
        str=file.gets
        grid[i]=str.split.collect { |x| x.to_i }
    }

    file.close
    File.delete(Solutionfile) if File.exist?(Solutionfile)
    return grid
end

def print_grid(grid)
    file=File.new(Solutionfile, "a")
    0.upto(8) { |i|
        0.upto(8) { |j|
            file.print "#{grid[i][j]} "
        }
        file.puts ""
    }

    file.puts ""
    file.close
end

solve(init_grid)
