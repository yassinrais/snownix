defmodule SnownixWeb.UtilsHelpers do
  @moduledoc """
  Utils.
  """

  def get_user_avatar(user) do
    if is_nil(user) or is_nil(user.avatar) do
      "/images/snownix-small.png"
    else
      user.avatar <>
        "?u=" <>
        (user.updated_at
         |> DateTime.from_naive!("Etc/UTC")
         |> DateTime.to_unix()
         |> Integer.to_string())
    end
  end
end
