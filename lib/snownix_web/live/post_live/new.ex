defmodule SnownixWeb.PostLive.New do
  use SnownixWeb, :live_view

  alias Snownix.Posts.Post

  def render(assigns) do
    ~H"""
     <section>
      <.live_component
        id={@id}
        module={SnownixWeb.PostLive.Components.FormComponent}
        title="New Post"
        action={:new}
        post={@post}
        return_to="/"

      />
     </section>
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:id, "new")
     |> assign(:post, %Post{})
     |> assign(:markdown, true)
     |> assign(:custom_slug, false)
     |> assign(:fullscreen, false)}
  end
end