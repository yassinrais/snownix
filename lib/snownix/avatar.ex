defmodule Snownix.Avatar do
  @moduledoc """
  Avatar Module

  Save , Resize, Remove avatar
  """
  import Mogrify

  @doc """
  Copy Avatarto static directory
  copy from source and paste to dest static and resize

  ## Examples

      iex> save_avatar("/tmp/xyz/jpg", "/avatars/user-1.jpg")
      "/avatars/user-1.jpg"
  """
  def save_avatar(source, dest) do
    static_dest =
      Path.join([
        :code.priv_dir(:snownix),
        "static",
        dest
      ])

    File.cp!(source, static_dest)
    # resize_avatar(static_dest)

    dest
  end

  @doc """
  Resize avatar

  ## Examples

      iex> resize_avatar("/avatars/user-1.jpg")
      %{ path: "/avatars/user-1.jpg", in_place: ...}

      iex> resize_avatar(nil)
      nil
  """
  def resize_avatar(avatar_path) do
    open(avatar_path) |> resize_to_limit("350x350") |> save()
  end

  def rm_user_avatar(nil), do: nil

  def rm_user_avatar(avatar) do
    avatar_path =
      Path.join([
        :code.priv_dir(:snownix),
        "static",
        avatar
      ])

    with String.contains?(avatar_path, "uploads") and File.exists?(avatar_path) do
      File.rm(avatar_path)
    end
  end
end
