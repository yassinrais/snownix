defmodule SnownixWeb.IndexLive.Index do
  use SnownixWeb, :live_view

  alias Snownix.Posts

  def mount(_, _, socket) do
    {:ok,
     socket
     |> assign(:page_title, gettext("Home"))
     |> assign_posts()}
  end

  def assign_posts(socket) do
    socket
    |> assign(
      :posts,
      Posts.last_posts()
    )
  end
end
