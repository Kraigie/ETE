defmodule ETE.Game.World do
  alias ETE.Game.Player

  @width 1000
  @height 600

  @derive Jason.Encoder 
  defstruct players: %{}, entities: [], height: @height, width: @width

  def new() do
    %__MODULE__{}
  end

  def add_player(%__MODULE__{players: players} = world, player_id) do
    x_pos = Enum.random(Player.default_width()..@width)
    y_pos = 0
    player = %Player{x: x_pos, y: y_pos}

    players = Map.put(players, player_id, player)

    %{world | players: players}
  end

  def set_moving(%__MODULE__{players: players} = world, player_id, orientation) do
    player =
      players
      |> Map.get(player_id)
      |> Player.set_moving(orientation)

    players = Map.put(players, player_id, player)

    %{world | players: players}
  end

  def stop_player(%__MODULE__{players: players} = world, player_id, orientation) do
    player =
      players
      |> Map.get(player_id)
      |> Player.stop_moving(orientation)

    players = Map.put(players, player_id, player)

    %{world | players: players}
  end

  def next_tick(%__MODULE__{players: players} = world) do
    players = Enum.reduce(players, %{}, fn {id, p}, acc -> Map.put(acc, id, Player.move_player(p)) end)
    %{world | players: players}
  end
end
