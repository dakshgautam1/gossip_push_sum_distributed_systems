defmodule Server.Boss do
  use GenServer

  #Interface APIs
  def start_boss(server_pid, total_servers) do
    GenServer.call(server_pid, {:start_time, total_servers})
  end

  def add_total_server(server_pid, value) do
    GenServer.call(server_pid, {:add_total_server, value})
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

  defp calculate_convergence(completed, total) do
    per = if completed != 0 and total != 0 do
      completed/total
    else
      0
    end
    per * 100
  end


  #Server APIs
  def init(max_time) do
    initial_state = %{
      start: -1,
      end: -1,
      acknowledged_servers: [],
      max_time: max_time,
      failed_servers: [],
      total_servers: 0,
      stop_server: false
    }
    Process.send_after(self(), :close_process, 10000000)
    {:ok, initial_state}
  end

  def handle_call({:start_time, total_servers}, _caller, state) do
    start_time = :os.system_time(:millisecond)
    new_state = %{
      start: start_time,
      end: -1,
      acknowledged_servers: state.acknowledged_servers,
      max_time: state.max_time,
      failed_servers: state.failed_servers,
      total_servers: total_servers,
      stop_server: state.stop_server

    }
    Process.send_after(self(), :close_process, state.max_time)
    {:reply, start_time, new_state}
  end

  def handle_call({:add_server, server_pid}, _caller, state) do
    new_state = if (state.stop_server == true) do
      state
    else
      new_acknowledged_servers = state.acknowledged_servers ++ [server_pid]
      total_time = :os.system_time(:millisecond) - state.start
      # if convergence < 10 do
      #   IO.puts "Total Nodes: #{state.total_servers} Node: #{inspect (server_pid)} Completed Nodes: #{length(state.acknowledged_servers)} Failed Nodes: #{length(state.failed_servers)} Time Taken : #{total_time} Convergence: #{convergence}%"
      # end

      new_state = %{
        start: state.start,
        end: -1,
        acknowledged_servers: new_acknowledged_servers,
        max_time: state.max_time,
        failed_servers: state.failed_servers,
        total_servers: state.total_servers,
        stop_server: state.stop_server
      }
      convergence = calculate_convergence(length(new_state.acknowledged_servers), new_state.total_servers)

      IO.puts "Total Nodes: #{new_state.total_servers} Node: #{inspect (server_pid)} Completed Nodes: #{length(new_state.acknowledged_servers)} Failed Nodes: #{length(new_state.failed_servers)} Time Taken : #{total_time} Convergence: #{convergence}%"

      new_state
    end

    {:reply, state.start, new_state}
  end

  def handle_call({:add_failed_server, server_pid}, _caller, state) do
    IO.puts "FAIL - Total Nodes: #{state.total_servers} Node: #{inspect (server_pid)} Completed Nodes: #{length(state.acknowledged_servers)} Failed Nodes: #{length(state.failed_servers)}"

    new_failed_servers = state.failed_servers ++ [server_pid]
    new_state = %{
      start: state.start,
      end: -1,
      acknowledged_servers: state.acknowledged_servers,
      max_time: state.max_time,
      failed_servers: new_failed_servers,
      total_servers: state.total_servers,
      stop_server: state.stop_server
    }
    {:reply, state.failed_servers, new_state}
  end

  def handle_call({:add_total_server, value}, _caller, state) do
    new_state = %{
      start: state.start,
      end: -1,
      acknowledged_servers: state.acknowledged_servers,
      max_time: state.max_time,
      failed_servers: state.failed_servers,
      total_servers: value,
      stop_server: state.stop_server

    }
    {:reply, state.total_servers, new_state}
  end

  def handle_call({:print}, _caller, state) do
    {:reply, state.acknowledged_servers, state}
  end

  def handle_info(:close_process, state) do
    convergence = calculate_convergence(length(state.acknowledged_servers), state.total_servers)

    IO.puts "Exiting Boss Server - CONVERGENCE #{convergence} Total: #{state.total_servers} Completed Servers: #{length(state.acknowledged_servers)}"
    #Process.exit(self(), :normal)
    new_state = %{
      start: state.start,
      end: -1,
      acknowledged_servers: state.acknowledged_servers,
      max_time: state.max_time,
      failed_servers: state.failed_servers,
      total_servers: state.total_servers,
      stop_server: true

    }

    {:noreply, new_state}
  end


end
