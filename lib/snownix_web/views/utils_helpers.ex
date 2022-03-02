defmodule SnownixWeb.UtilsHelpers do
  @moduledoc """
  Utils.
  """

  def get_user_avatar(user) do
    (!is_nil(user) && user.avatar) || "/images/snownix-small.png"
  end
end
