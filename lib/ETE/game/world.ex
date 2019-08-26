defmodule ETE.Game.World do
  alias ETE.Game.Entities

  defstruct [:entities]

  def new() do
    %__MODULE__{entities: %Entities{}}
  end

  def add_player(%__MODULE__{entities: entities} =  world, player_id) do
    new_entities = Entities.add_player(entities, player_id)
    %{world | entities: new_entities}
  end

  def move_player(world, player_id, value) do
    new_entities = Entities.move_player(world.entities, player_id, value)
    %{world | entities: new_entities}
  end

  def next_tick(world) do
    world
  end
end