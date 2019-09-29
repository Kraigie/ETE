defmodule ETE.Game.World do
  alias ETE.Game.Player

  @width 800
  @height 800

  @derive Jason.Encoder
  defstruct players: %{}, entities: [], height: @height, width: @width, game_id: nil

  def new(game_id) do
    %__MODULE__{game_id: game_id}
  end

  def add_player(%__MODULE__{players: players} = world, player_id) do
    x_pos = Enum.random(Player.default_width()..@width)
    y_pos = Enum.random(Player.default_height()..@height)
    player = %Player{x: x_pos, y: y_pos}

    players = Map.put(players, player_id, player)

    %{world | players: players}
  end

  def remove_player(%__MODULE__{players: players} = world, player_id) do
    {_, players} = Map.pop(players, player_id)
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
    players =
      Enum.reduce(players, %{}, fn {id, p}, acc -> Map.put(acc, id, Player.move_player(p)) end)

    %{world | players: players}
  end
end
