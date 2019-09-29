defmodule ETE.Game.World do
  alias ETE.Cat
  alias ETE.Game.Entity

  @width 800
  @height 800
  @max_entity_speed 10

  @derive Jason.Encoder
  defstruct players: %{},
            entities: %{},
            height: @height,
            width: @width,
            game_id: nil,
            tick: 0,
            entity_counter: 0

  def new(game_id) do
    %__MODULE__{game_id: game_id}
  end

  def add_player(%__MODULE__{players: players} = world, player_id, cat) do
    x_pos = Enum.random(Entity.default_width()..@width)
    y_pos = Enum.random(Entity.default_height()..@height)
    player = %Entity{x: x_pos, y: y_pos, avatar: cat}

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
      |> Entity.set_moving(orientation)

    players = Map.put(players, player_id, player)

    %{world | players: players}
  end

  def stop_player(%__MODULE__{players: players} = world, player_id, orientation) do
    player =
      players
      |> Map.get(player_id)
      |> Entity.stop_moving(orientation)

    players = Map.put(players, player_id, player)

    %{world | players: players}
  end

  def toggle_hitboxes(%__MODULE__{players: players} = world, player_id) do
    player =
      players
      |> Map.get(player_id)
      |> Entity.toggle_hitbox()

    players = Map.put(players, player_id, player)

    %{world | players: players}
  end

  def next_tick(%__MODULE__{} = world) do
    world =
      world
      |> move_players()
      |> move_entities()
      |> create_new_entities()
      |> update_tick()

    world
  end

  defp move_players(%__MODULE__{players: players} = world) do
    players =
      Enum.reduce(players, %{}, fn {id, p}, acc -> Map.put(acc, id, Entity.move_player(p)) end)

    %{world | players: players}
  end

  defp move_entities(%__MODULE__{entities: entities} = world) do
    entities =
      Enum.reduce(entities, %{}, fn {num, e}, acc ->
        moved_entity = Entity.move_entity(e)

        if is_out_of_bounds(moved_entity) do
          acc
        else
          Map.put(acc, num, Entity.move_entity(e))
        end
      end)

    %{world | entities: entities}
  end

  defp pos(x), do: x
  defp neg(x), do: x * -1
  defp pos_or_neg(x), do: if(:rand.uniform() >= 0.5, do: x * -1, else: x)

  defp create_new_entities(%__MODULE__{entities: entities} = world) do
    if map_size(entities) < 4 do
      side = Enum.random([:top, :left, :right, :bottom])
      position = :rand.uniform()

      vx = :rand.uniform(@max_entity_speed)
      vy = :rand.uniform(@max_entity_speed)

      {x, y, vx, vy} =
        case side do
          :top -> {position * @width, 0, pos_or_neg(vx), pos(vy)}
          :bottom -> {position * @width, @height, pos_or_neg(vx), neg(vy)}
          :left -> {0, position * @height, pos(vx), pos_or_neg(vy)}
          :right -> {@width, position * @height, neg(vx), pos_or_neg(vy)}
        end

      entity = %Entity{
        x: x,
        y: y,
        vx: vx,
        vy: vy,
        avatar: elem(Cat.get_bad_girl(), 0)
      }

      %{world | entities: Map.put(entities, Integer.to_string(world.tick), entity)}
    else
      world
    end
  end

  defp is_out_of_bounds(entity) do
    entity.x >= @width or entity.x <= 0 or entity.y >= @height or entity.y <= 0
  end

  defp update_tick(%__MODULE__{tick: tick} = world), do: %{world | tick: tick + 1}
end
