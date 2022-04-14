defmodule SnownixWeb.AccountLive.Profile do
  use SnownixWeb, :live_view

  alias Snownix.Accounts
  alias Snownix.{Posts, Posts.Post, Pagination, Repo}

  def mount(%{"username" => username}, _session, socket) do
    {:ok,
     socket
     |> assign_profile(username)
     |> assign_posts()
     |> assign_meta_tags()}
  end

  defp assign_meta_tags(socket) do
    %{username: username} = socket.assigns

    socket
    |> put_meta_tags(%{
      page_title: gettext("%{username} Profile", username: username),
      page_desc: gettext("User %{username} posts", username: username),
      page_keywords: "#{username},blog,articles,posts,snownix,phoenix,self hosted,open source"
    })
  end

  defp assign_profile(socket, username) do
    profile = Accounts.get_user_by_username!(username)

    socket
    |> assign(:username, username)
    |> assign(:profile, profile)
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
      |> Posts.by_user(socket.assigns.username)
      |> Posts.order_posts()
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
