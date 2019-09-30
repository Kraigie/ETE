defmodule ETE.Game.World do
  alias ETE.Cat
  alias ETE.Game.Entity

  @width 800
  @height 800
  @max_entity_count 4
  @speed 5
  @entity_height 50
  @entity_width 50

  @derive Jason.Encoder
  defstruct players: %{},
            entities: %{},
            height: @height,
            width: @width,
            game_id: nil,
            tick: 0,
            entity_counter: 0,
            speed_modifier: 1.0,
            high_scores: %{}

  def new(game_id) do
    %__MODULE__{game_id: game_id}
  end

  def add_player(%__MODULE__{players: players} = world, player_id, cat) do
    x_pos = Enum.random(@entity_width..@width)
    y_pos = Enum.random(@entity_height..@height)

    entity =
      create_entity(player: true, id: player_id, x: x_pos, y: y_pos, avatar: cat, vx: 0, vy: 0)

    players = Map.put(players, entity.id, entity)

    %{world | players: players}
  end

  def remove_player(%__MODULE__{players: players} = world, player_id) do
    {_, players} = Map.pop(players, player_id)
    %{world | players: players}
  end

  def set_moving(%__MODULE__{players: players} = world, player_id, orientation) do
    player = Map.get(players, player_id)

    if player do
      players = Map.put(players, player_id, Entity.set_moving(player, orientation))
      %{world | players: players}
    else
      world
    end
  end

  def stop_player(%__MODULE__{players: players} = world, player_id, orientation) do
    player = Map.get(players, player_id)

    if player do
      players = Map.put(players, player_id, Entity.stop_moving(player, orientation))
      %{world | players: players}
    else
      world
    end
  end

  def toggle_hitboxes(%__MODULE__{players: players} = world, player_id) do
    player = Map.get(players, player_id)

    if player do
      players = Map.put(players, player_id, Entity.toggle_hitbox(player))
      %{world | players: players}
    else
      world
    end
  end

  def add_lucy(%__MODULE__{entities: entities} = world, :normal) do
    entity = create_entity(id: Integer.to_string(world.tick))
    %{world | entities: Map.put(entities, entity.id, entity)}
  end

  def add_lucy(%__MODULE__{entities: entities} = world, :big) do
    entity =
      create_entity(
        id: Integer.to_string(world.tick),
        height: @entity_height * 4,
        width: @entity_width * 4,
        speed: @speed / 2
      )

    %{world | entities: Map.put(entities, entity.id, entity)}
  end

  def change_enemy_speed(%__MODULE__{speed_modifier: mod} = world, :faster) when mod <= 3.0,
    do: %{world | speed_modifier: mod + 0.1}

  def change_enemy_speed(%__MODULE__{speed_modifier: mod} = world, :slower) when mod >= 0.2,
    do: %{world | speed_modifier: mod - 0.1}

  def change_enemy_speed(%__MODULE__{} = world, _speed), do: world

  def next_tick(%__MODULE__{} = world) do
    world =
      world
      |> move_players()
      |> move_entities()
      |> handle_collisions()
      |> create_new_entities()
      |> update_tick()

    world
  end

  defp move_players(%__MODULE__{players: players} = world) do
    players =
      Enum.reduce(players, %{}, fn {id, p}, acc -> Map.put(acc, id, Entity.move_player(p)) end)

    %{world | players: players}
  end

  def handle_collisions(%__MODULE__{entities: entities, players: players} = world) do
    dead =
      for {_entity_id, entity} <- entities, {player_id, player} <- players do
        if overlaps?(entity, player) do
          player_id
        end
      end

    players = Map.drop(players, dead)

    %{world | players: players}
  end

  def overlaps?(rect1, rect2) do
    !(rect1.x + rect1.width < rect2.x or rect2.x + rect2.width < rect1.x or
        rect1.y + rect1.height < rect2.y or rect2.y + rect2.height < rect1.y)
  end

  defp move_entities(%__MODULE__{entities: entities} = world) do
    entities =
      Enum.reduce(entities, %{}, fn {num, e}, acc ->
        moved_entity = Entity.move_entity(e, world.speed_modifier)

        if is_out_of_bounds?(moved_entity) do
          acc
        else
          Map.put(acc, num, moved_entity)
        end
      end)

    %{world | entities: entities}
  end

  defp pos(x), do: x
  defp neg(x), do: x * -1.0
  defp pos_or_neg(x), do: if(:rand.uniform() >= 0.5, do: x * -1.0, else: x)

  defp create_entity(opts) do
    side = Enum.random([:top, :left, :right, :bottom])
    position = :rand.uniform()

    max_speed = opts |> Keyword.get(:speed, @speed) |> round()

    vx = :rand.uniform(max_speed)
    vy = :rand.uniform(max_speed)

    height = Keyword.get(opts, :height, @entity_height)
    width = Keyword.get(opts, :width, @entity_width)

    {x, y, vx, vy} =
      case side do
        :top -> {position * @width, 0 - height + 1, pos_or_neg(vx), pos(vy)}
        :bottom -> {position * @width, @height, pos_or_neg(vx), neg(vy)}
        :left -> {0 - width + 1, position * @height, pos(vx), pos_or_neg(vy)}
        :right -> {@width, position * @height, neg(vx), pos_or_neg(vy)}
      end

    x = Keyword.get(opts, :x, x)
    y = Keyword.get(opts, :y, y)
    vx = Keyword.get(opts, :vx, vx)
    vy = Keyword.get(opts, :vy, vy)
    avatar = Keyword.get(opts, :avatar, "lucy")
    id = Keyword.get(opts, :id, nil)

    %Entity{
      id: id,
      x: x,
      y: y,
      vx: vx,
      vy: vy,
      height: height,
      width: width,
      avatar: avatar,
      speed: @speed
    }
  end

  defp create_new_entities(%__MODULE__{entities: entities} = world) do
    if map_size(entities) < @max_entity_count do
      entity =
        create_entity(
          id: Integer.to_string(world.tick),
          speed: @speed * 1.5,
          avatar: elem(Cat.get_bad_girl(), 0)
        )

      %{world | entities: Map.put(entities, entity.id, entity)}
    else
      world
    end
  end

  def is_out_of_bounds?(entity) do
    entity.x > @width or entity.x < 0 - entity.width or entity.y > @height or
      entity.y < 0 - entity.height
  end

  defp update_tick(%__MODULE__{tick: tick, players: players, high_scores: high_scores} = world) do
    players =
      players
      |> Enum.map(fn {id, player} -> {id, Entity.add_points(player)} end)
      |> Enum.into(%{})

    high_scores =
      players
      |> Enum.map(fn {_k, v} -> v end)
      |> Kernel.++(high_scores)
      |> Enum.sort(&(&1.score >= &2.score))
      |> Enum.uniq_by(fn player -> player.id end)
      |> Enum.take(10)

    %{world | tick: tick + 1, players: players, high_scores: high_scores}
  end

  def default_speed() do
    @speed
  end

  def default_height() do
    @entity_height
  end

  def default_width() do
    @entity_width
  end
end
