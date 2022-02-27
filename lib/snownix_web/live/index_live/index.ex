defmodule SnownixWeb.IndexLive.Index do
  use SnownixWeb, :live_view

  def mount(_, _, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Home")}
  end
end
