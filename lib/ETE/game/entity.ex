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
            speed: 5,
            latest_x_movement: nil,
            latest_y_movement: nil,
            x_movement: [],
            y_movement: []

  def set_moving(%__MODULE__{speed: speed} = player, orientation) do
    # We need to use Enum.uniq here because we sometimes get multiple key_down's in
    # the same direction before we get a key_up
    case orientation do
      :up ->
        %{
          player
          | vy: -speed,
            latest_y_movement: orientation,
            y_movement: Enum.uniq([orientation | player.y_movement])
        }

      :down ->
        %{
          player
          | vy: speed,
            latest_y_movement: orientation,
            y_movement: Enum.uniq([orientation | player.y_movement])
        }

      :left ->
        %{
          player
          | vx: -speed,
            latest_x_movement: orientation,
            x_movement: Enum.uniq([orientation | player.x_movement])
        }

      :right ->
        %{
          player
          | vx: speed,
            latest_x_movement: orientation,
            x_movement: Enum.uniq([orientation | player.x_movement])
        }
    end
  end

  def stop_moving(%__MODULE__{} = player, orientation) do
    case orientation do
      :up ->
        if orientation == player.latest_y_movement do
          y_movement = List.delete(player.y_movement, orientation)

          if length(y_movement) == 1 do
            %{player | vy: player.speed, y_movement: y_movement, latest_y_movement: :down}
          else
            %{player | vy: 0, y_movement: y_movement, latest_y_movement: nil}
          end
        else
          y_movement = List.delete(player.y_movement, orientation)
          %{player | y_movement: y_movement, latest_y_movement: :down}
        end

      :down ->
        if orientation == player.latest_y_movement do
          y_movement = List.delete(player.y_movement, orientation)

          if length(y_movement) == 1 do
            %{player | vy: player.speed * -1, y_movement: y_movement, latest_y_movement: :up}
          else
            %{player | vy: 0, y_movement: y_movement, latest_y_movement: nil}
          end
        else
          y_movement = List.delete(player.y_movement, orientation)
          %{player | y_movement: y_movement, latest_y_movement: :up}
        end

      :left ->
        if orientation == player.latest_x_movement do
          x_movement = List.delete(player.x_movement, orientation)

          if length(x_movement) == 1 do
            %{player | vx: player.speed, x_movement: x_movement, latest_x_movement: :right}
          else
            %{player | vx: 0, x_movement: x_movement, latest_x_movement: nil}
          end
        else
          x_movement = List.delete(player.x_movement, orientation)
          %{player | x_movement: x_movement, latest_x_movement: :right}
        end

      :right ->
        if orientation == player.latest_x_movement do
          x_movement = List.delete(player.x_movement, orientation)

          if length(x_movement) == 1 do
            %{player | vx: player.speed * -1, x_movement: x_movement, latest_x_movement: :left}
          else
            %{player | vx: 0, x_movement: x_movement, latest_x_movement: nil}
          end
        else
          x_movement = List.delete(player.x_movement, orientation)
          %{player | x_movement: x_movement, latest_x_movement: :doleftwn}
        end
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
    %{player | show_hitboxes: !show}
  end

  def default_width do
    @width
  end

  def default_height do
    @height
  end
end
