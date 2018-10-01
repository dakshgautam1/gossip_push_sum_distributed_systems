defmodule Server.Pushserver do

  alias Server.Pushserver
  alias Server.Boss
  use GenServer
  # Interface APIs
  def add_connections(server_id, connections) do
    GenServer.call(server_id, {:add_connections, connections})
  end

  def start_process(server_id) do
    GenServer.cast(server_id, {:start_process})
  end

  def propagate_message(server_id, s, w) do
    GenServer.cast(server_id, {:send_recv_msg, s, w})
  end

  def remove_connection(server_id, connection_id) do
    GenServer.call(server_id, {:delete_connection, connection_id})
  end


  #Server

  def init({s_value, boss_pid}) do
    intial_state = %{
      s: s_value,
      w: 1,
      rumors: 0,
      ratios: [],
      connections: [],
      boss_pid: boss_pid,
      saturated: false,
    }
    {:ok, intial_state}
  end


  def handle_call({:add_connections, conn_list}, _caller, state) do
    #IO.puts "Genserver: #{inspect(self())} add connections: #{inspect(conn_list)}"
    new_list = state.connections ++ conn_list
    new_state = %{
      s: state.s,
      w: state.w,
      ratios: state.ratios,
      rumors: state.rumors,
      connections: new_list,
      boss_pid: state.boss_pid,
      saturated: state.saturated,
    }
    {:reply, state.connections, new_state}
  end

  def handle_call({:delete_connection, connection_id}, _caller,state) do
    new_connections = List.delete(state.connections, connection_id)
    new_state = %{
      s: state.s,
      w: state.w,
      ratios: state.ratios,
      rumors: state.rumors,
      connections: new_connections,
      boss_pid: state.boss_pid,
      saturated: state.saturated,
    }
    {:reply, state.connections, new_state}
  end


  def handle_cast({:start_process}, state) do
    IO.puts "I have started the process #{inspect(self())} with s: #{inspect(state.s)}  w: #{inspect(state.w)}"

    {new_s, new_w} = trigger(state)
    new_state = %{
      s: new_s,
      w: new_w,
      ratios: state.ratios,
      rumors: state.rumors,
      connections: state.connections,
      boss_pid: state.boss_pid,
      saturated: state.saturated,

    }

    {:noreply, new_state}
  end

  def handle_cast({:send_recv_msg, s, w}, state) do


    if (state.saturated == true) do
      {:noreply, state}
    else
    new_s = state.s + s
    new_w = state.w + w


    #half
    half_s = new_s/2
    half_w = new_w/2
    new_rumors = state.rumors + 1




    #check if here is your ratio is acheieved
    ratio = half_s/half_w
    {new_ratios, is_saturated} = check_proximity(state.ratios, ratio)

    #IO.puts "New ratios #{inspect(new_ratios)} for #{inspect(self())}"
    # IO.puts "#{ratio} Genserver: #{inspect(self())}, #{is_saturated} with s: #{inspect(s)}  w: #{inspect(w)} my half_s #{half_s} half_w #{half_w}"

    if (is_saturated == true) do
      IO.puts "#{ratio} Genserver: #{inspect(self())} Ratio-list - #{inspect(new_ratios)}"
      Enum.each(state.connections, fn(connection) ->
        Pushserver.remove_connection(connection, self()) end)
      Boss.add_completed_server(state.boss_pid, self())
    end



    # Create new state
    new_state = %{
      s: half_s,
      w: half_w,
      ratios: new_ratios,
      rumors: new_rumors,
      connections: state.connections,
      boss_pid: state.boss_pid,
      saturated: is_saturated
    }


    # send a msg
    connections = state.connections
    len = length(connections)
    if len > 0 do
      random_pid = Enum.at(connections, :rand.uniform(len) - 1)
      # IO.puts "Got the rumor #{new_rumors} for #{inspect(self())}"
      # GenServer.cast(random_pid, {:send_recv_msg, half_s, half_w})
      Pushserver.propagate_message(random_pid, half_s, half_w)
    end

    {:noreply, new_state}
    end
  end


  # Server Utitliy Functions
  defp trigger(state) do
    connections = state.connections
    len = length(connections)
    if len > 0 do
     random_pid = Enum.at(connections, :rand.uniform(len) - 1)
     new_s = state.s/2
     new_w = state.w/2
     Pushserver.propagate_message(random_pid, new_s, new_w)
     {new_s, new_w}
    else
      {state.s, state.w}
    end
 end


 defp check_within_limits(ratios) do
  first = Enum.at(ratios, 0)
  second = Enum.at(ratios, 1)
  third = Enum.at(ratios, 2)
  thresh_value = :math.pow(10, -10)

  result = if abs(first-second) < thresh_value and abs(second-third) < thresh_value and abs(first-second) < thresh_value do
    true
  else
    false
  end
  result
 end

 defp check_proximity(ratios, new_value) do
   len = length(ratios)
   {new_ratios, is_saturated} = if (len < 2) do
      new_custom_list = ratios ++ [new_value]
      {new_custom_list, false}
   else
      custom_list = if (len == 2) do
        ratios ++ [new_value]
        else
        # IO.inspect "before: #{inspect ratios}"
        half_list = List.delete_at(ratios, 0)
        # IO.inspect "after: #{inspect half_list}"
        half_list ++ [new_value]
      end
      custom_saturation = check_within_limits(custom_list)
      {custom_list, custom_saturation}
   end
   {new_ratios, is_saturated}
 end

end
