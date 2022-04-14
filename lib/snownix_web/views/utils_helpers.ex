defmodule SnownixWeb.UtilsHelpers do
  @moduledoc """
  Utils.
  """

  def get_user_avatar(user) do
    if is_nil(user) or is_nil(user.avatar) do
      "/images/snownix-small.png"
    else
      Snownix.Uploaders.AvatarUploader.url({user.avatar, user}, :thumb)
    end
  end

  def get_post_poster(post, size \\ :thumb) do
    case post do
      %{poster: poster} ->
        Snownix.Uploaders.PosterUploader.url({poster, post}, size)

      _ ->
        nil
    end
  end
end
