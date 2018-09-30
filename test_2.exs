defmodule Test1 do
    def create2d do
        nodes = [1,2,3,4,5]
        j=0
        acc=[]
        Enum.each(0..5,fn(i) ->
            list=Enum.reduce(nodes, [], fn(x, acc) ->  
                newj=j+1
                acc ++ [[x,i,newj]]
            end) 
            IO.inspect list
            newj=0
        end)
            acc
    end

    # def v2 do
    #     list=[[]]
    #     Enum.each(0..5,fn(x)->
    #         Enum.each(0..5,fn(y)-> 
    #             temp=[[x,y]]
    #             List.insert_at(list,Enum.count(list)-1,temp)
    #             IO.inspect mainList
    #         end)
    #     end)
        
    # end

    def v3 do
        map=Map.new()
        Enum.each(0..5,fn(i)->
            mapTemp= Map.new()
            Enum.each(0..5,fn(j) ->
                mapTemp=Map.new()
                 
            end) 
        end)
        map2 = %{
            0 => %{0 => "a"},
            1 => %{1 => "b"}
        }
        board = %{
            0 => %{0 => "x", 1 => "o", 2 => "x"},
            1 => %{0 => "x", 1 => "o", 2 => "o"},
            2 => %{0 => "o", 1 => "x", 2 => "o"}
          }
          IO.puts map2[0][0]
        IO.puts board[0][0]
        
    end
    
    def sphere(nodes) do
        count=trunc(:math.sqrt(Enum.count(nodes)))
        IO.puts count  
        width = count
        Enum.each(1..(count-2),fn(y) -> 
            Enum.each(1..(count-2),fn(x) -> 
                x1=x+1
                x2=x-1
                y1=y+1
                y2=y-1
                index1 = x1 + width*y
                index2 = x2 + width*y
                index3 = x + width*y1
                index4 = x + width*y2
                connections = [Enum.at(nodes,index1),Enum.at(nodes,index2),Enum.at(nodes,index3),Enum.at(nodes,index4)]
                #IO.inspect connections
            end)
        end)

        #for y co-ordinate zero
        y=0
        Enum.each(1..(count-2),fn(x) -> 
            y_below=1
            y_top=count-1
            x_left=x-1
            x_right=x+1
            index1 = x_left + width*y
            index2 = x_right + width*y
            index3 = x + width* y_below
            index4 = x + width* y_top
            connections = [Enum.at(nodes,index1),Enum.at(nodes,index2),Enum.at(nodes,index3),Enum.at(nodes,index4)]
            #IO.inspect connections 
        end)

        # for y co-ordinate last
        y=count-1
        Enum.count(1..(count-2),fn(x) -> 
            x_left=x-1
            x_right=x+1
            y_below=0
            y_top=count-2
            index1 = x_left + width*y
            index2 = x_right + width*y
            index3 = x + width* y_below
            index4 = x + width* y_top
            connections = [Enum.at(nodes,index1),Enum.at(nodes,index2),Enum.at(nodes,index3),Enum.at(nodes,index4)]
            #IO.inspect connections
        end)

        #top left node
        index1=(count-1)
        index2=1
        index3=0+width*(count-1)
        index4=0+width*(1)
        connections = [Enum.at(nodes,index1),Enum.at(nodes,index2),Enum.at(nodes,index3),Enum.at(nodes,index4)]
        #IO.inspect connections

        #top right node
        index1 = count-2
        index2 = 0
        index3 = (count-1) + width*1
        index4 = (count-1) + width*(count-1)
        connections = [Enum.at(nodes,index1),Enum.at(nodes,index2),Enum.at(nodes,index3),Enum.at(nodes,index4)]
        # IO.inspect connections

        #bottom left node
        index1 = count-1 + width*(count-1)
        index2 = 1 + width*(count-1)
        index3 = 0 + width*(count-2)
        index4 = 0
        connections = [Enum.at(nodes,index1),Enum.at(nodes,index2),Enum.at(nodes,index3),Enum.at(nodes,index4)]
        # IO.inspect connections

        #bottom right node
        index1 = (count-2) + width*(count-1)
        index2 = 0 + width*(count-1)
        index3 = (count-1) + width*0
        index4 = (count-1) + width*(count-2)
        connections = [Enum.at(nodes,index1),Enum.at(nodes,index2),Enum.at(nodes,index3),Enum.at(nodes,index4)]
        IO.inspect connections

    end
end