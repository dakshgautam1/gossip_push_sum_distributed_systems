defmodule Topology do

  alias Server.Gossipserver
  alias Server.Pushserver

  defp calculateNodesDist(nodes, index) do
    start = Enum.at(nodes, index)
    Enum.map(nodes, fn(node) -> pointDistance(Enum.at(start, 1), Enum.at(start, 2), Enum.at(node, 1), Enum.at(node, 2)) end)
    |> Enum.with_index
    |> Enum.filter(fn({number, _index}) -> number < 0.1 end)
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
        # IO.puts "#{inspect(node)} created connections #{length(nodes)}"
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
    Enum.each(
      nodes,
      fn(node) ->
        index = Enum.find_index(nodes, fn(x) -> x == node end)
        connections =
          cond do
            index == 0 -> [Enum.at(nodes,index+1)]
            index == (Enum.count(nodes) -1) -> [Enum.at(nodes,index - 1)]
            true -> [Enum.at(nodes,index-1), Enum.at(nodes,index+1)]
          end

          random_node = Enum.at(nodes, :rand.uniform(length(nodes)) - 1)
          new_connections = if (Enum.any?(connections, fn(y) -> y == random_node end) == false) and random_node != node do
            new_x = connections ++ [random_node]
            new_x
          else
            connections
          end

        # IO.puts "#{inspect(node)} created connections #{inspect(connections)}"
        if (algorithm == "gossip") do
          Gossipserver.add_connections(node, new_connections)
        else
          Pushserver.add_connections(node, new_connections)
        end

      end
    )

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
