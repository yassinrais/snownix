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

    case File.cp(source, static_dest) do
      :ok ->
        # IO.inspect("Copy Done")
        # resize_avatar(static_dest)
        dest

      {:error, raison} ->
        # IO.inspect(raison, label: "raison: ")
        nil
    end
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
    IO.inspect(avatar_path, label: "Before Resize")
    IO.inspect(open(avatar_path) |> verbose, label: "Resize Done")

    open(avatar_path)
    |> gravity("Center")
    |> resize_to_fill("400x400")
    |> save(path: avatar_path)

    IO.inspect(avatar_path, label: "Resize Done")
    IO.inspect(open(avatar_path) |> verbose, label: "Resize Done")
    IO.inspect(File.exists?(avatar_path), label: "File Exists ???? ")
  end

  def rm_user_avatar(nil), do: nil

  def rm_user_avatar(avatar) do
    avatar_path =
      Path.join([
        :code.priv_dir(:snownix),
        "static",
        avatar
      ])

    case String.contains?(avatar_path, "uploads/") and File.exists?(avatar_path) do
      true ->
        File.rm(avatar_path)
        true

      _ ->
        false
    end
  end
end
