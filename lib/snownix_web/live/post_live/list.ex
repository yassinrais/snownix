defmodule SnownixWeb.PostLive.List do
  use SnownixWeb, :live_view

  alias Snownix.{Posts.Post, Pagination, Repo}

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_posts()}
  end

  def handle_params(_, _, socket) do
    {:noreply, socket}
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
      Post
      |> Pagination.page(page, per_page: 6)

    pagination = %{
      pagination
      | items: pagination.items |> Repo.preload(:author)
    }

    socket |> assign(:pagination, pagination)
  end
end
