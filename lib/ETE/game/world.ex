defmodule ETE.Game.World do
  alias ETE.Game.Player

  defstruct players: %{}, entities: []

  def new() do
    %__MODULE__{}
  end

  def add_player(%__MODULE__{players: players} = world, player_id) do
    x_pos = Enum.random(5..95)
    y_pos = 0
    player = %Player{x_pos: x_pos, y_pos: y_pos}

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
