defmodule ETE.Game.Player do
  defstruct x_pos: 0, y_pos: 0, height: 5, width: 5, speed: 0.5, direction: {nil, nil}

  def set_moving(%__MODULE__{direction: dir} = player, orientation)
      when orientation in [:left, :right] do
    direction = put_elem(dir, 0, orientation)
    %{player | direction: direction}
  end

  def set_moving(%__MODULE__{direction: dir} = player, orientation)
      when orientation in [:up, :down] do
    direction = put_elem(dir, 1, orientation)
    %{player | direction: direction}
  end

  def stop_moving(%__MODULE__{direction: dir} = player, orientation)
      when orientation in [:left, :right] do
    direction = put_elem(dir, 0, nil)
    %{player | direction: direction}
  end

  def stop_moving(%__MODULE__{direction: dir} = player, orientation)
      when orientation in [:up, :down] do
    direction = put_elem(dir, 1, nil)
    %{player | direction: direction}
  end

  def move_player(%__MODULE__{} = player) do
    player
    |> move_x()
    |> move_y()
  end

  defp move_x(%__MODULE__{x_pos: x_pos, speed: speed, direction: {x, _}} = player) do
    case x do
      :left -> %{player | x_pos: x_pos - speed}
      :right -> %{player | x_pos: x_pos + speed}
      :nil -> player
    end
  end

  defp move_y(%__MODULE__{y_pos: y_pos, speed: speed, direction: {_, y}} = player) do
    case y do
      :up -> %{player | y_pos: y_pos + speed}
      :down -> %{player | y_pos: y_pos - speed}
      :nil -> player
    end
  end
end
