defmodule ETE.Game.Server do
  use GenServer

  alias ETE.Game.World

  @ms_per_tick 33

  def start_link(_default) do
    GenServer.start_link(__MODULE__, %{world: World.new()}, name: __MODULE__)
  end

  def add_player(player_id) do
    GenServer.cast(__MODULE__, {:add_player, player_id})
  end

  def move_player(player_id, value) do
    GenServer.cast(__MODULE__, {:move_player, player_id, value})
  end

  def get_world() do
    GenServer.call(__MODULE__, :get_world)
  end

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
    Process.send_after(self(), {:tick, time}, time)
    {:noreply, %{state | world: world}}
  end

  @impl true
  def handle_cast({:add_player, player_id}, state) do
    world = World.add_player(state.world, player_id)
    {:noreply, %{state | world: world}}
  end

  @impl true
  def handle_cast({:move_player, player_id, value}, state) do
    world = World.move_player(state.world, player_id, value)
    {:noreply, %{state | world: world}}
  end

  @impl true
  def handle_call(:get_world, _from, state) do
    {:reply, state.world, state}
  end
end
