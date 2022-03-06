defmodule Snownix.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Snownix.Posts` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        description: "some description",
        poster: "some poster",
        published_at: ~N[2022-03-05 19:27:00],
        slug: "some slug",
        title: "some title"
      })
      |> Snownix.Posts.create_post()

    post
  end
end
