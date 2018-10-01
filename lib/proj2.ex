defmodule PROJ2 do
  # TODO: check edge cases whent he list is empty
  # TODO: find the distance.

  # Topologies here
  alias Server.Gossipserver
  alias Server.Pushserver
  alias Server.Boss

  import Topology, only: [create_topology: 3]

  # Creates Gossip Node
  def create_gossip_node(nodeNumber, boss_pid) do
    nodeName = String.to_atom("node#{nodeNumber}")
    {:ok, pid} = GenServer.start(Gossipserver, boss_pid, name: nodeName)
    pid
  end

  def create_push_node(nodeNumber, boss_pid) do
    nodeName = String.to_atom("node#{nodeNumber}")
    {:ok, pid} = GenServer.start(Pushserver, {nodeNumber+1, boss_pid}, name: nodeName)
    pid
  end

  def num_generator_sphere(num) do
    low = trunc(:math.sqrt(num))
    high = low * low
    high
  end

  def num_generator_3d(num) do
    half = trunc(num/2)
    low = trunc(:math.sqrt(half))
    middle = low * low
    high = middle * 2
    high
  end


  def modify_num_nodes(num_nodes, topology) do
    cond do
      topology == "sphere" -> num_generator_sphere(num_nodes)
      topology == "grid3d" -> num_generator_3d(num_nodes)
      true -> num_nodes
    end
  end

  def main(args) do
    num_nodes = String.to_integer(Enum.at(args,0))
    algorithm = Enum.at(args,1)
    topology = Enum.at(args, 2)

    num_nodes = modify_num_nodes(num_nodes, topology)

    {:ok, boss_pid} = GenServer.start(Boss, 10000000, name: :boss)

    if algorithm == "gossip" do
      node_list = Enum.map((1..num_nodes),fn(x) -> create_gossip_node(x, boss_pid) end)
      create_topology(topology, node_list, algorithm)
      # IO.inspect node_list
      len = length(node_list)
      if len > 0 do
        Boss.start_boss(boss_pid, len)
        Gossipserver.send_msg(Enum.at(node_list, :rand.uniform(len) - 1))
      end
      boss_pid
    end

    if algorithm =="push-sum" do
      node_list = Enum.map((1..num_nodes),fn(x) -> create_push_node(x, boss_pid) end)
      create_topology(topology, node_list, algorithm)
      # IO.inspect node_list
      len = length(node_list)
      if len > 0 do
        Boss.start_boss(boss_pid, len)
        # :rand.uniform(len) - 1
        Pushserver.start_process(Enum.at(node_list, 0))
      end
      nil
    end

    boss_pid
  end

end



# @moduledoc """
#   Documentation for PROJ2.
#   """

#   @doc """
#   Hello world.

#   ## Examples

#       iex> PROJ2.hello()
#       :world

#   """

  # defmodule PushSum do
  #   use GenServer
  #   def init(messages) do
  #     {:ok, messages}
  #   end
  #   def createNodes(numberOfNodes) do
  #     if numberOfNodes > 0 do
  #       nodeName = String.to_atom("node#{numberOfNodes}")
  #       {:ok, pid} = GenServer.start_link(PushSum, 1, name: nodeName)
  #       :global.register_name(nodeName,pid)
  #       createNodes(numberOfNodes - 1)
  #     end
  #   end
  #   def createSingleNode(nodeNumber) do
  #     nodeName = String.to_atom("node#{nodeNumber}")
  #     {:ok, pid} = GenServer.start_link(PushSum, 1, name: nodeName)
  #     pid
  #   end
  #   #do stuff for PushSum
  # end



