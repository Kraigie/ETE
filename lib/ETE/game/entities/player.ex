defmodule ETE.Game.Entities.Player do
  defstruct [:x_pos, :y_pos]

  def move_player(%__MODULE__{x_pos: x_pos} = player, value) do
    x_pos = x_pos + value

    %{player | x_pos: x_pos}
  end
end