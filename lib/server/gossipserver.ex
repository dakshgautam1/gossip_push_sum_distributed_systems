defmodule Server.Gossipserver do
  alias Server.Gossipserver
  alias Server.Boss
  use GenServer

  @timeout 1000
  # Interface APIs
  def add_connections(server_id, connections) do
    GenServer.call(server_id, {:add_connections, connections})
  end

  def printIt(server_id) do
    GenServer.call(server_id, {:print})
  end

  def send_msg(server_id) do
    GenServer.cast(server_id, {:recv_msg})
  end

  def remove_connection(server_id, connection_id) do
    GenServer.call(server_id, {:delete_connection, connection_id})
  end


  # Server APIs
  def init(boss_pid) do
    # IO.puts "Server started #{inspect(boss_pid)}"
    random_number = :rand.uniform(10000)
    mod = rem(random_number, 25)
    IO.puts "random no : #{random_number} "
    if mod == 0 do
      Process.send_after(self(), :fail, 10)
    end

    map = %{
      rumors: 0,
      connections: [],
      boss_pid: boss_pid,
      is_failed: false
    }
    {:ok, map}
  end

  # Call Functions
  def handle_call({:add_connections, conn_list}, _caller,state) do
    # IO.puts "Genserver: #{inspect(self())} add connections: #{inspect(conn_list)}"
    new_list = state.connections ++ conn_list
    new_state = %{
      rumors: state.rumors,
      connections: new_list,
      boss_pid: state.boss_pid,
      is_failed: state.is_failed
    }
    {:reply, state.connections, new_state}
  end

  def handle_call({:print}, _caller, state) do
    {:reply, state.connections, state}
  end


  def handle_call({:delete_connection, connection_id}, _caller,state) do
    new_connections = List.delete(state.connections, connection_id)
    new_state = %{
      rumors: state.rumors,
      connections: new_connections,
      boss_pid: state.boss_pid,
      is_failed: state.is_failed
    }
    {:reply, state.connections, new_state, 1000}
  end


  # Cast Functions
  def handle_cast({:recv_msg}, state) do

    returned_value = if state.rumors >= 10 do
      # IO.puts "I am already done"
      {:noreply, state}
    else
      #add a rumor
      new_rumors = state.rumors + 1
      new_state = %{
        rumors: new_rumors,
        connections: state.connections,
        boss_pid: state.boss_pid,
        is_failed: state.is_failed
      }

      #remove myself from my neighbours
      if new_rumors == 10 do
       #IO.puts "mera kaam ho gya #{inspect(self())}"
        try do
          Enum.each(state.connections, fn(connection) ->
            Gossipserver.remove_connection(connection, self()) end)
          Boss.add_completed_server(state.boss_pid, self())
        catch
          :exit, _ -> IO.puts "caught exit"
        end
      end

      #send a rumor
      connections = state.connections
      len = length(connections)
      if len > 0 do
        random_pid = Enum.at(connections, :rand.uniform(len) - 1)
        # IO.puts "Got the rumor #{new_rumors} for #{inspect(self())} start sending msg #{inspect(random_pid)}"

        try do
          GenServer.cast(random_pid, {:recv_msg})
        catch
          :exit, _ -> IO.puts "caught exit"
        end
      end

      # if new_rumors == 10 do
      #   Process.send_after(self(), :close_process, 1000)
      # end

      {:noreply, new_state}
    end
    returned_value
  end


  def handle_info(:close_process, state) do
    IO.puts "Exiting it#{inspect(state.acknowledged_servers)} with start: #{state.start} with #{:os.system_time(:millisecond)}"
    # Process.exit(self(), :normal)
    {:noreply, state}
  end

  def handle_info(:fail, state) do
    IO.puts "Fail it for #{inspect self()}"

    Enum.each(state.connections, fn(connection) ->
      Gossipserver.remove_connection(connection, self()) end)
    Boss.add_failed_server(state.boss_pid, self())

    new_state = %{
      rumors: state.rumors,
      connections: [],
      boss_pid: state.boss_pid,
      is_failed: true
    }

    {:noreply, new_state}
  end

  def handle_info(:timeout, _) do
    IO.puts "yello"
		{:noreply, :normal, []}
	end


end
