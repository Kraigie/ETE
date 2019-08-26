defmodule ETE.Game.Entities.Player do
  defstruct x_pos: 0, y_pos: 0

  def move_player(%__MODULE__{x_pos: x_pos} = player, value) do
    x_pos = x_pos + value

    %{player | x_pos: x_pos}
  end
end
