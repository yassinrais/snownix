defmodule SnownixWeb.IndexLive.Index do
  use SnownixWeb, :live_view

  alias Snownix.Posts

  def mount(_, _, socket) do
    {:ok,
     socket
     |> assign(:page_title, gettext("Home"))
     |> assign_meta_tags()
     |> assign_posts()}
  end

  def assign_posts(socket) do
    socket
    |> assign(
      :posts,
      Posts.last_posts()
    )
  end

  defp assign_meta_tags(socket) do
    socket
    |> put_meta_tags(%{
      page_title: gettext("Home"),
      page_desc: gettext("A Next-level blog application for futuristic people"),
      page_keywords: "blog,articles,posts,snownix,phoenix,self hosted,open source"
    })
  end
end
