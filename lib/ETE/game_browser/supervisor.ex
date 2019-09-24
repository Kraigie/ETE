defmodule ETE.GameBrowser.Supervisor do
  use DynamicSupervisor

  alias ETE.Game.Server

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(id) do
    DynamicSupervisor.start_child(__MODULE__, {Server, id})
  end

  def list_children() do
    __MODULE__
    |> DynamicSupervisor.which_children()
    |> Enum.map(fn {_, pid, _, _} -> pid end)
  end
end
