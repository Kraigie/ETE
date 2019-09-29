defmodule ETEWeb.GameView do
  use ETEWeb, :view

  def show_hitbox?(%{players: players}, player_id) do
    %{^player_id => %{show_hitboxes: show}} = players
    show
  end
end
