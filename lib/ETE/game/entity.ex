defmodule ETE.Game.Entity do
  @height 50
  @width 50

  @derive Jason.Encoder
  defstruct show_hitboxes: false,
            avatar: nil,
            x: 0,
            y: 0,
            height: @height,
            width: @width,
            vx: 0,
            vy: 0,
            speed: 5

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

  def set_avatar(%__MODULE__{} = player, avatar) do
    %{player | avatar: avatar}
  end

  def move_player(%__MODULE__{} = player) do
    move(player)
  end

  def move(%__MODULE__{x: x, y: y, vx: vx, vy: vy} = player) do
    x = x + vx
    y = y + vy
    %{player | x: x, y: y}
  end

  def move_entity(%__MODULE__{x: x, y: y, vx: vx, vy: vy} = entity) do
    x = x + vx
    y = y + vy
    %{entity | x: x, y: y}
  end

  def toggle_hitbox(%__MODULE__{show_hitboxes: show} = player) do
    %{player | show_hitboxes: !player.show_hitboxes}
  end

  def default_width do
    @width
  end

  def default_height do
    @height
  end
end
