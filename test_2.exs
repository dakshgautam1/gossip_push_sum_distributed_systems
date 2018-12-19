defmodule Test1 do

    def sphere(nodes) do
        count=trunc(:math.sqrt(Enum.count(nodes)))
        # IO.puts count
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
                nodeHereIndex= x + width*y
                nodeHere = Enum.at(nodes,nodeHereIndex)
                connectionGenerator(nodeHereIndex,nodeHere,connections,nodes)
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
            nodeHereIndex= x + width*0
            nodeHere = Enum.at(nodes,nodeHereIndex)
            connectionGenerator(nodeHereIndex,nodeHere,connections,nodes)
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
            nodeHereIndex= x + width*(count-1)
            nodeHere = Enum.at(nodes,nodeHereIndex)
            connectionGenerator(nodeHereIndex,nodeHere,connections,nodes)
        end)

        #top left node
        index1=(count-1)
        index2=1
        index3=0+width*(count-1)
        index4=0+width*(1)
        connections = [Enum.at(nodes,index1),Enum.at(nodes,index2),Enum.at(nodes,index3),Enum.at(nodes,index4)]
        nodeHereIndex= 0 + width*0
        nodeHere = Enum.at(nodes,nodeHereIndex)
        connectionGenerator(nodeHereIndex,nodeHere,connections,nodes)


        #top right node
        index1 = count-2
        index2 = 0
        index3 = (count-1) + width*1
        index4 = (count-1) + width*(count-1)
        connections = [Enum.at(nodes,index1),Enum.at(nodes,index2),Enum.at(nodes,index3),Enum.at(nodes,index4)]
        nodeHereIndex= (count-1) + width*0
        nodeHere = Enum.at(nodes,nodeHereIndex)
        connectionGenerator(nodeHereIndex,nodeHere,connections,nodes)

        #bottom left node
        index1 = count-1 + width*(count-1)
        index2 = 1 + width*(count-1)
        index3 = 0 + width*(count-2)
        index4 = 0
        connections = [Enum.at(nodes,index1),Enum.at(nodes,index2),Enum.at(nodes,index3),Enum.at(nodes,index4)]
        nodeHereIndex= 0 + width*(count-1)
        nodeHere = Enum.at(nodes,nodeHereIndex)
        connectionGenerator(nodeHereIndex,nodeHere,connections,nodes)

        #bottom right node
        index1 = (count-2) + width*(count-1)
        index2 = 0 + width*(count-1)
        index3 = (count-1) + width*0
        index4 = (count-1) + width*(count-2)
        connections = [Enum.at(nodes,index1),Enum.at(nodes,index2),Enum.at(nodes,index3),Enum.at(nodes,index4)]
        nodeHereIndex= (count-1) + width*(count-1)
        nodeHere = Enum.at(nodes,nodeHereIndex)
        connectionGenerator(nodeHereIndex,nodeHere,connections,nodes)
    end

    def connectionGenerator(nodeHereIndex,node,nodeList,allNodes) do
        IO.inspect Enum.at(allNodes,nodeHereIndex)
        IO.inspect nodeList
        # call function to update neighbour for this node
    end

    def grid3d(nodes) do
        countTotal=Enum.count(nodes)
        countHalfGrid=trunc(countTotal/2)
        width=trunc(:math.sqrt(countHalfGrid))
        height=width
        #middle part grid
        Enum.each(0..1,fn(z) ->
            Enum.each(1..(width-2),fn(y) ->
                Enum.each(1..(width-2),fn(x) ->
                    x_left=x-1
                    x_right=x+1
                    y_top=y-1
                    y_below=y+1
                    z_here = if z == 0 do
                        1
                    else
                        0
                    end
                    index1=x_left + width*y + width*height*z
                    index2=x_right + width*y + width*height*z
                    index3=x + width*y_below + width*height*z
                    index4=x + width*y_top + width*height*z
                    index5=x + width*y + width*height*z_here
                    connections = [Enum.at(nodes,index1),Enum.at(nodes,index2),Enum.at(nodes,index3),Enum.at(nodes,index4),Enum.at(nodes,index5)]
                    nodeHereIndex= x + width*y + width*height*z
                    nodeHere = Enum.at(nodes,nodeHereIndex)
                    connectionGenerator(nodeHereIndex,nodeHere,connections,nodes)
                    # IO.inspect connections
                end)
            end)
        end)

        #for y co-ordinate zero
        Enum.each(0..1,fn(z) ->
            Enum.each(1..(width-2),fn(x) ->
                x_left=x-1
                x_right=x+1
                y_below=1
                z_here = if z == 0 do
                    1
                else
                    0
                end
                index1=x_left + width*0 + width*height*z
                index2=x_right + width*0 + width*height*z
                index3=x + width*y_below + width*height*z
                index4=x + width*0 + width*height*z_here
                connections = [Enum.at(nodes,index1),Enum.at(nodes,index2),Enum.at(nodes,index3),Enum.at(nodes,index4)]
                nodeHereIndex= x + width*0 + width*height*z
                nodeHere = Enum.at(nodes,nodeHereIndex)
                connectionGenerator(nodeHereIndex,nodeHere,connections,nodes)
                # IO.inspect connections
            end)
        end)

        #for y co-oridante last
        Enum.each(0..1,fn(z) ->
            Enum.each(1..(width-2),fn(x) ->
                x_left=x-1
                x_right=x+1
                y_top = width-2
                z_here = if z == 0 do
                    1
                else
                    0
                end
                index1=x_left + width*(width-1) + width*height*z
                index2=x_right + width*(width-1) + width*height*z
                index3=x + width*y_top + width*height*z
                index4=x + width*(width-1) + width*height*z_here
                connections = [Enum.at(nodes,index1),Enum.at(nodes,index2),Enum.at(nodes,index3),Enum.at(nodes,index4)]
                nodeHereIndex= x + width*(width-1) + width*height*z
                nodeHere = Enum.at(nodes,nodeHereIndex)
                connectionGenerator(nodeHereIndex,nodeHere,connections,nodes)
                # IO.inspect connections
            end)
        end)

        #top left nodes
        Enum.each(0..1,fn(z) ->
            x_right=1
            y_below=1
            z_here = if z == 0 do
                1
            else
                0
            end
            index1=x_right + width*0 + width*height*z
            index2=0 + width*y_below + width*height*z
            index3=0 + width*0 + width*height*z_here
            connections = [Enum.at(nodes,index1),Enum.at(nodes,index2),Enum.at(nodes,index3)]
            nodeHereIndex= 0 + width*0 + width*height*z
            nodeHere = Enum.at(nodes,nodeHereIndex)
            connectionGenerator(nodeHereIndex,nodeHere,connections,nodes)
            # IO.inspect connections
        end)
        #top right nodes
        Enum.each(0..1,fn(z) ->
            x_left=width-2
            y_below=1
            z_here = if z == 0 do
                1
            else
                0
            end
            index1=x_left + width*0 + width*height*z
            index2=(width-1) + width*y_below + width*height*z
            index3=(width-1) + width*(0) + width*height*z_here
            connections = [Enum.at(nodes,index1),Enum.at(nodes,index2),Enum.at(nodes,index3)]
            nodeHereIndex= (width-1) + width*0 + width*height*z
            nodeHere = Enum.at(nodes,nodeHereIndex)
            connectionGenerator(nodeHereIndex,nodeHere,connections,nodes)
            # IO.inspect connections
        end)
        #bottom left nodes
        Enum.each(0..1,fn(z) ->
            x_right=1
            y_top=width-2
            z_here = if z == 0 do
                1
            else
                0
            end
            index1=x_right + width*(width-1) + width*height*z
            index2=(0) + width*y_top + width*height*z
            index3=(0) + width*(width-1) + width*height*z_here
            connections = [Enum.at(nodes,index1),Enum.at(nodes,index2),Enum.at(nodes,index3)]
            nodeHereIndex= 0 + width*(width-1) + width*height*z
            nodeHere = Enum.at(nodes,nodeHereIndex)
            connectionGenerator(nodeHereIndex,nodeHere,connections,nodes)
            # IO.inspect connections
        end)
        #bottom right nodes
        Enum.each(0..1,fn(z) ->
            x_left=(width-2)
            y_top=width-2
            z_here = if z == 0 do
                1
            else
                0
            end
            index1=x_left + width*(width-1) + width*height*z
            index2=(width-1) + width*y_top + width*height*z
            index3=(width-1) + width*(width-1) + width*height*z_here
            connections = [Enum.at(nodes,index1),Enum.at(nodes,index2),Enum.at(nodes,index3)]
            nodeHereIndex= (width-1) + width*(width-1) + width*height*z
            nodeHere = Enum.at(nodes,nodeHereIndex)
            connectionGenerator(nodeHereIndex,nodeHere,connections,nodes)
            # IO.inspect connections
        end)
    end
end
