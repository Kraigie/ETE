defmodule ETE.Game.Server do
  use GenServer

  alias ETE.Game.World

  @ms_per_tick 33 

  def start_link(_default) do
    GenServer.start_link(__MODULE__, %{world: World.new()}, name: __MODULE__)
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
  def handle_cast({:move_player, player_id, value}, state) do
    world = World.move_player(state.world, player_id, value)
    {:noreply, %{state | world: world}}
  end
end