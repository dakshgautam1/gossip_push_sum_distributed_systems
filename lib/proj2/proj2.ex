defmodule PROJ2 do
  @moduledoc """
  Documentation for PROJ2.
  """

  @doc """
  Hello world.

  ## Examples

      iex> PROJ2.hello()
      :world

  """
  

  defmodule Gossip do
    use GenServer
    def init(messages) do
      {:ok, messages}
    end
    def createNodes(numberOfNodes) do
      if numberOfNodes > 0 do
        nodeName = String.to_atom("node#{numberOfNodes}")
        {:ok, pid} = GenServer.start_link(Gossip, 1, name: nodeName)
        :global.register_name(nodeName,pid)
        IO.puts(nodeName)
        createNodes(numberOfNodes - 1)
      end
    end
    def createSingleNode(nodeNumber) do
      nodeName = String.to_atom("node#{nodeNumber}")
      {:ok, pid} = GenServer.start_link(Gossip, 1, name: nodeName)
      IO.puts(nodeName)
      pid
    end
    #do stuff for Gossip
  end

  defmodule PushSum do
    use GenServer
    def init(messages) do
      {:ok, messages}
    end
    def createNodes(numberOfNodes) do
      if numberOfNodes > 0 do
        nodeName = String.to_atom("node#{numberOfNodes}")
        {:ok, pid} = GenServer.start_link(PushSum, 1, name: nodeName)
        :global.register_name(nodeName,pid)
        createNodes(numberOfNodes - 1)
      end
    end
    def createSingleNode(nodeNumber) do
      nodeName = String.to_atom("node#{nodeNumber}")
      {:ok, pid} = GenServer.start_link(PushSum, 1, name: nodeName)
      pid
    end
    #do stuff for PushSum
  end

  
  def calculateNodesDist(nodes, index) do
    start = Enum.at(nodes, index)
    Enum.map(nodes, fn(node) -> pointDistance(Enum.at(start, 1), Enum.at(start, 2), Enum.at(node, 1), Enum.at(node, 2)) end)
    |> Enum.with_index
    |> Enum.filter(fn({number, index}) -> number < 1 end)
    |> Enum.map(fn({number, index}) -> Enum.at(nodes, index) |>  Enum.at(0) end)
  end
 
 
 
  def pointDistance(x1, y1, x2, y2) do
    :math.sqrt(:math.pow(x1 - x2, 2) + :math.pow(y1 - y2, 2))
  end
 
  def createTopology(topology,nodes) do
    if topology == "full" do
      Enum.each(nodes,fn(x) -> neighbours = List.delete(nodes,x) end)
    end

    if topology == "line" do
      Enum.each(nodes,fn(k) -> 
        index=Enum.find_index(nodes,fn(x) -> x==k end)
        cond do
          index == 0 ->
            neighbours = [Enum.at(nodes,index+1)]
          
          index == (Enum.count(nodes) -1) ->
            neighbours = [Enum.at(nodes,index - 1)]
          
          true -> 
            neighbours = [Enum.at(nodes,index-1),Enum.at(nodes,index+1)]
        end
      end
      )
    end

    if topology == "random2d" do
      mainList = Enum.reduce(nodes, [], fn(x, acc) ->  acc ++ [[x,:rand.uniform(1000)/1000,:rand.uniform(1000)/1000]] end)
      Enum.each(nodes,fn(k) -> 
        index=Enum.find_index(nodes,fn(x) -> x==k end)
        checkedList = calculateNodesDist(mainList,index)
        neighbours = List.delete_at(checkedList,index)
      end)
      
    end

    if topology =="impline" do
      Enum.each(nodes,fn(k) -> 
        index=Enum.find_index(nodes,fn(x) -> x==k end)
        cond do
          index == 0 ->
            randNumberIndex = :rand.uniform(Enum.count(nodes-1))
            if randNumberIndex == 0 do
              randNumberIndex = 2
            end
            neighbours = [Enum.at(nodes,index+1),Enum.at(nodes,randNumberIndex)]
          
          index == (Enum.count(nodes) -1) ->
            neighbours = [Enum.at(nodes,index - 1)]
            #add random here and check for edge case
          true -> 
            #add random here and check for edge case
            randNumberIndex = :rand.uniform(Enum.count(nodes-1))
            if randNumberIndex == index || randNumberIndex == index-1 || randNumberIndex == index+1  do
              randNumberIndex = :rand.uniform(Enum.count(nodes-1))
            end
            neighbours = [Enum.at(nodes,index-1),Enum.at(nodes,index+1),Enum.at(nodes,randNumberIndex)]
        end
        
        #add random another neighbour to list
      end )
    end
  end


  def main(args) do
    numNodes = String.to_integer(Enum.at(args,0))
    #topology = Enum.at(args,1)
    algorithm = Enum.at(args,1)

    if algorithm == "gossip" do
      #Gossip.createNodes(numNodes)
      nodeList = Enum.map((1..numNodes),fn(x) -> Gossip.createSingleNode(x) end)
      IO.inspect nodeList
      # {:ok, pid1} = GenServer.start_link(MasterNode, [], name: :"nodeMaster")
      # :global.register_name(:"nodeMaster",pid1)
      # :global.sync()
      # #nodeName = String.to_atom("node#{startingNode}")
      # do stuff for gossip
    end

    if algorithm =="push-sum" do
      #PushSum.createNodes(numNodes)
      nodeList = Enum.each((1..numNodes),fn(x) -> PushSum.createSingleNode(x) end)
      # {:ok, pid1} = GenServer.start_link(MasterNode, [], name: :"nodeMaster")
      # :global.register_name(:"nodeMaster",pid1)
      # :global.sync()
      # #nodeName = String.to_atom("node#{startingNode}")
      # do stuff for push sum
    end

  end

  def hello do
    :world
  end
end
