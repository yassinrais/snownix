defmodule SnownixWeb.IndexLive.Index do
  use SnownixWeb, :live_view

  alias Snownix.Posts

  def mount(_, _, socket) do
    {:ok,
     socket
     |> assign_posts()
     |> assign(:page_title, gettext("Home"))}
  end

  def assign_posts(socket) do
    socket |> assign(:posts, Posts.list_posts())
  end
end
