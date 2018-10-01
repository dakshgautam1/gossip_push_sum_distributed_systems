defmodule Topology do

  alias Server.Gossipserver
  alias Server.Pushserver

  defp calculateNodesDist(nodes, index) do
    start = Enum.at(nodes, index)
    Enum.map(nodes, fn(node) -> pointDistance(Enum.at(start, 1), Enum.at(start, 2), Enum.at(node, 1), Enum.at(node, 2)) end)
    |> Enum.with_index
    |> Enum.filter(fn({number, _index}) -> number < 1 end)
    |> Enum.map(fn({_number, index}) -> Enum.at(nodes, index) |>  Enum.at(0) end)
  end

  defp pointDistance(x1, y1, x2, y2) do
    :math.sqrt(:math.pow(x1 - x2, 2) + :math.pow(y1 - y2, 2))
  end

  def create_topology("line", nodes, algorithm) do
    Enum.each(
      nodes,
      fn(node) ->
        index = Enum.find_index(nodes, fn(x) -> x == node end)
        connections =
          cond do
            index == 0 -> [Enum.at(nodes,index+1)]
            index == (Enum.count(nodes) -1) -> [Enum.at(nodes,index - 1)]
            true -> [Enum.at(nodes,index-1),Enum.at(nodes,index+1)]
          end
        # IO.puts "#{inspect(node)} created connections #{inspect(connections)}"
        if (algorithm == "gossip") do
          Gossipserver.add_connections(node, connections)
        else
          Pushserver.add_connections(node, connections)
        end

      end
    )
  end

  def create_topology("random2d", nodes, algorithm) do
    main_list = Enum.reduce(
                  nodes,
                  [],
                  fn(x, acc) -> acc ++ [[x,:rand.uniform(1000)/1000,:rand.uniform(1000)/1000]] end )
    Enum.each(
      nodes,
      fn(node) ->
        index = Enum.find_index(nodes, fn(x) -> x == node end)
        checkedList = calculateNodesDist(main_list, index)
        index2 = Enum.find_index(checkedList, fn(x) -> x == node end)
        connections = List.delete_at(checkedList, index2)

        if (algorithm == "gossip") do
          Gossipserver.add_connections(node, connections)
        else
          Pushserver.add_connections(node, connections)
        end
      end
    )
  end


  def create_topology("impline", nodes, algorithm) do
      Enum.each(nodes,fn(k) ->
        index=Enum.find_index(nodes,fn(x) -> x==k end)
        connections = cond do
          index == 0 ->
            randNumberIndex = :rand.uniform(Enum.count(nodes)-1)
            if randNumberIndex == 0 do
              randNumberIndex = 2
            end
            [Enum.at(nodes,index+1),Enum.at(nodes,randNumberIndex)]

          index == (Enum.count(nodes) -1) ->
            randNumberIndex = :rand.uniform(Enum.count(nodes)-1)
            if randNumberIndex == index || randNumberIndex == (index-1) do
              [Enum.at(nodes,index - 1),Enum.at(nodes,index-2)]
            else
              [Enum.at(nodes,index-1),Enum.at(nodes,randNumberIndex)]
            end

          true ->
            #add random here and check for edge case
            current_random_number = :rand.uniform(Enum.count(nodes)-1)
            current_random_number = if current_random_number == index || current_random_number == index-1 || current_random_number == index+1  do
              :rand.uniform(Enum.count(nodes)-1)
            end
             [Enum.at(nodes,index-1),Enum.at(nodes,index+1),Enum.at(nodes,current_random_number)]
        end

        if (algorithm == "gossip") do
          Gossipserver.add_connections(k, connections)
        else
          Pushserver.add_connections(k, connections)
        end

        #IO.inspect connections
        connections
      end )

  end

  def create_topology("full", nodes, algorithm) do
    Enum.each(nodes, fn(node) ->
      connections = List.delete(nodes, node)

      if (algorithm == "gossip") do
        Gossipserver.add_connections(node, connections)
      else
        Pushserver.add_connections(node, connections)
      end
    end
    )
  end

  def create_topology("sphere", nodes, algorithm) do
    Topology.Complex.sphere(nodes, algorithm)
  end

  def create_topology("grid3d", nodes, algorithm) do
    Topology.Complex.grid3d(nodes, algorithm)
  end

  # def create_topology(topology, nodes, algorithm) do
  #   if topology == "full" do

  #   end
  # end

end
