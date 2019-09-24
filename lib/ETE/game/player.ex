defmodule ETE.Game.Player do
  @height 20
  @width 20

  @derive Jason.Encoder
  defstruct x: 0, y: 0, height: @height, width: @width, vx: 0, vy: 0, speed: 5

  def set_moving(%__MODULE__{speed: speed} = player, orientation) do
    case orientation do
      :up -> %{player | vy: -speed}
      :down -> %{player | vy: speed}
      :left -> %{player | vx: -speed}
      :right -> %{player | vx: speed}
    end
  end

  def stop_moving(%__MODULE__{} = player, orientation) do
    case orientation do
      :up -> %{player | vy: 0}
      :down -> %{player | vy: 0}
      :left -> %{player | vx: 0}
      :right -> %{player | vx: 0}
    end
  end

  def move_player(%__MODULE__{} = player) do
    move(player)
  end

  def move(%__MODULE__{x: x, y: y, vx: vx, vy: vy} = player) do
    x = x + vx
    y = y + vy
    %{player | x: x, y: y}
  end

  def default_width do
    @width
  end

  def default_height do
    @height
  end
end
