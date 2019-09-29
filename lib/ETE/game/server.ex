defmodule ETE.Game.Server do
  use GenServer, restart: :temporary

  alias ETE.Game.World

  @ms_per_tick 16
  @registry ETE.GameBrowser.Registry
  @shutdown_timeout 5000

  def start_link(game_id) do
    GenServer.start_link(__MODULE__, %{world: World.new(game_id), connected: %{}},
      name: via_tuple(game_id)
    )
  end

  def add_connected(game_id, player_id, view_pid) do
    GenServer.cast(via_tuple(game_id), {:add_connected, player_id, view_pid})
  end

  def add_player(game_id, player_id, cat) do
    GenServer.cast(via_tuple(game_id), {:add_player, player_id, cat})
  end

  def set_moving(game_id, player_id, orientation) do
    GenServer.cast(via_tuple(game_id), {:set_moving, player_id, orientation})
  end

  def stop_moving(game_id, player_id, orientation) do
    GenServer.cast(via_tuple(game_id), {:stop_player, player_id, orientation})
  end

  def get_world(pid) when is_pid(pid), do: GenServer.call(pid, :get_world)
  def get_world(id), do: GenServer.call(via_tuple(id), :get_world)

  @impl true
  def init(state) do
    {:ok, state, {:continue, @ms_per_tick}}
  end

  @impl true
  def handle_continue(time, state) do
    Process.send_after(self(), {:tick, time}, time)
    {:noreply, state}
  end

  @impl true
  def handle_info({:tick, time}, state) do
    world = World.next_tick(state.world)

    for {pid, _id} <- state.connected, do: send(pid, {:render, world})
    Process.send_after(self(), {:tick, time}, time)

    {:noreply, %{state | world: world}}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, pid, _reason}, state) do
    {popped, connected} = Map.pop(state.connected, pid)
    world = World.remove_player(state.world, popped)

    if map_size(connected) <= 0, do: Process.send_after(self(), :stop, @shutdown_timeout)

    {:noreply, %{state | connected: connected, world: world}}
  end

  @impl true
  def handle_info(:stop, %{connected: connected} = state) do
    if map_size(connected) <= 0, do: {:stop, :shutdown, state}, else: {:noreply, state}
  end

  @impl true
  def handle_cast({:add_connected, player_id, view_pid}, state) do
    Process.monitor(view_pid)
    {:noreply, %{state | connected: Map.put(state.connected, view_pid, player_id)}}
  end

  @impl true
  def handle_cast({:add_player, player_id, cat}, state) do
    world = World.add_player(state.world, player_id, cat)
    {:noreply, %{state | world: world}}
  end

  @impl true
  def handle_cast({:set_moving, player_id, orientation}, state) do
    world = World.set_moving(state.world, player_id, orientation)
    {:noreply, %{state | world: world}}
  end

  @impl true
  def handle_cast({:stop_player, player_id, orientation}, state) do
    world = World.stop_player(state.world, player_id, orientation)
    {:noreply, %{state | world: world}}
  end

  @impl true
  def handle_call(:get_world, _from, state) do
    {:reply, state.world, state}
  end

  defp via_tuple(id), do: {:via, Registry, {@registry, id}}
end
