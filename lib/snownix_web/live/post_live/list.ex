defmodule SnownixWeb.PostLive.List do
  use SnownixWeb, :live_view

  alias Snownix.{Posts, Posts.Post, Pagination, Repo}

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_meta_tags()
     |> assign_posts()}
  end

  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  defp assign_meta_tags(socket) do
    socket
    |> put_meta_tags(%{
      page_title: gettext("Posts"),
      page_desc: gettext("A Next-level blog application for futuristic people"),
      page_keywords: "blog,articles,posts,snownix,phoenix,self hosted,open source"
    })
  end

  def handle_event("page", params, socket) do
    %{"page" => page} = params
    {:noreply, socket |> load_more(page: String.to_integer(page))}
  end

  def assign_posts(socket) do
    socket
    |> assign(:pagination, [])
    |> load_more(page: 1)
  end

  def load_more(socket, page: page) when page < 0, do: socket

  def load_more(socket, page: page) do
    pagination =
      Posts.order_posts(Post)
      |> Pagination.page(page, per_page: 6)

    pagination = %{
      pagination
      | items:
          pagination.items
          |> Repo.preload(:author)
          |> Repo.preload(:categories)
    }

    socket |> assign(:pagination, pagination)
  end
end
