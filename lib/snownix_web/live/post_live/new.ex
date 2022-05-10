defmodule SnownixWeb.PostLive.New do
  use SnownixWeb, :live_view

  alias Snownix.Posts.Post
  alias Snownix.Posts.Entity

  def render(assigns) do
    ~H"""
     <section>
      <.live_component
        id={@id}
        module={SnownixWeb.PostLive.Components.FormComponent}
        action={:new}
        title="New Post"
        post={@post}
        current_user={@current_user}
        return_to="/"
      />
     </section>
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:id, "new")
     |> assign(:post, %Post{
       entities: [%Entity{}]
     })
     |> assign(:markdown, true)
     |> assign(:custom_slug, false)
     |> assign(:fullscreen, false)}
  end
end
