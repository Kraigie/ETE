defmodule ETEWeb.GameBrowserLive do
  use Phoenix.LiveView

  alias ETE.Game.Server
  alias ETE.GameBrowser.Supervisor
  alias ETEWeb.Router.Helpers, as: Routes

  @tick 33

  def render(assigns) do
    ETEWeb.GameBrowserView.render("game_browser.html", assigns)
  end

  def mount(_session, socket) do
    worlds =
      Supervisor.list_children()
      |> Enum.map(fn pid -> Server.get_world(pid) end)

    Process.send_after(self(), {:tick, @tick}, @tick)

    {:ok, assign(socket, games: worlds)}
  end

  def handle_info({:tick, time}, socket) do
    worlds =
      Supervisor.list_children()
      |> Enum.map(fn pid -> Server.get_world(pid) end)

    Process.send_after(self(), {:tick, time}, time)

    {:noreply, assign(socket, games: worlds)}
  end

  def handle_info(%{event: "add_game", payload: p}, socket) do
    {:noreply, assign(socket, games: [Server.get_world(p.id) | socket.assigns.games])}
  end

  def handle_event("join_game", %{"id" => id}, socket) do
    {:noreply, live_redirect(socket, to: Routes.live_path(socket, ETEWeb.GameLive, id))}
  end

  def handle_event("create_new_game", _value, socket) do
    id = Ecto.UUID.generate()

    Supervisor.start_child(id)

    {:noreply, live_redirect(socket, to: Routes.live_path(socket, ETEWeb.GameLive, id))}
  end
end
