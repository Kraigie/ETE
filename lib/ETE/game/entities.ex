defmodule ETE.Game.Entities do
  alias ETE.Game.Entities.Player

  defstruct players: %{}, projectiles: []

  def add_player(%__MODULE__{} = entities, player_id) do
    x_pos = Enum.random(5..95)
    y_pos = 0
    player = %Player{x_pos: x_pos, y_pos: y_pos}

    players = Map.put(entities.players, player_id, player)

    %{entities | players: players}
  end

  def move_player(%__MODULE__{} = entities, player_id, value) do
    player =
      entities.players
      |> Map.get(player_id)
      |> Player.move_player(value)

    players = Map.put(entities.players, player_id, player)
    %{entities | players: players}
  end
end
