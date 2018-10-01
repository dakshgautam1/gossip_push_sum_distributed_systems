defmodule Server.Boss do
  use GenServer

  #Interface APIs
  def start_boss(server_pid) do
    GenServer.call(server_pid, {:start_time})
  end

  def add_completed_server(server_pid, completed_server_id) do
    GenServer.call(server_pid, {:add_server, completed_server_id})
  end

  def print(server_pid) do
    GenServer.call(server_pid, {:print})
  end

  def add_failed_server(server_pid, failed_server_id) do
    GenServer.call(server_pid, {:add_failed_server, failed_server_id})
  end

  #Server APIs
  def init(max_time) do
    initial_state = %{
      start: -1,
      end: -1,
      acknowledged_servers: [],
      max_time: max_time,
      failed_servers: []
    }
    {:ok, initial_state}
  end

  def handle_call({:start_time}, _caller, state) do
    start_time = :os.system_time(:millisecond)
    new_state = %{
      start: start_time,
      end: -1,
      acknowledged_servers: state.acknowledged_servers,
      max_time: state.max_time,
      failed_servers: []
    }
    Process.send_after(self(), :close_process, state.max_time)
    {:reply, start_time, new_state}
  end

  def handle_call({:add_server, server_pid}, _caller, state) do
    new_acknowledged_servers = state.acknowledged_servers ++ [server_pid]
    new_state = %{
      start: state.start,
      end: -1,
      acknowledged_servers: new_acknowledged_servers,
      max_time: state.max_time,
      failed_servers: []
    }
    IO.puts "received length: #{length(state.acknowledged_servers)} -  #{state.start - :os.system_time(:millisecond)}"
    {:reply, state.start, new_state}
  end

  def handle_call({:add_failed_server, server_pid}, _caller, state) do

  end

  def handle_call({:print}, _caller, state) do
    {:reply, state.acknowledged_servers, state}
  end

  def handle_info(:close_process, state) do
    IO.puts "Exiting it#{inspect(state.acknowledged_servers)} with start: #{state.start} with #{:os.system_time(:millisecond)}"
    #Process.exit(self(), :normal)
    {:noreply, state}
  end


end
