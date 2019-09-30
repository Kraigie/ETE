defmodule ETEWeb.GameView do
  use ETEWeb, :view

  def is_dead?(%{players: players}, _player_id) when map_size(players) == 0, do: true

  def is_dead?(%{players: players}, player_id), do: Enum.member?(players, player_id)

  def show_hitbox?(%{players: %{}}, _player_id) do
    false
  end

  def show_hitbox?(%{players: players}, player_id) do
    %{^player_id => %{show_hitboxes: show}} = players
    show
  end
end
