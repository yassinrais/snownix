defmodule Snownix.Avatar do
  @moduledoc """
  Avatar Module

  Save , Resize, Remove avatar
  """
  import Mogrify
  alias Snownix.Storage

  @doc """
  Upload Avatar to static directory/S3
  Upload from source and paste to dest static and resize

  ## Examples

      iex> upload_avatar("/tmp/xyz/jpg", "/avatars/user-1.jpg")
      "/avatars/user-1.jpg"
  """
  @bucket_name "snownix"
  def upload_avatar(filename, source, dest) do
    static_dest =
      Path.join([
        :code.priv_dir(:snownix),
        "static",
        dest
      ])

    case File.cp(source, static_dest) do
      :ok ->
        resize_avatar(source)

        if Application.fetch_env!(:ex_aws, :enable) do
          {:ok, binary} = File.read(source)

          case Storage.upload_file(@bucket_name, filename, binary) do
            {:ok, url} ->
              url

            _ ->
              nil
          end
        else
          dest
        end

      _ ->
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
    open(avatar_path)
    |> gravity("Center")
    |> resize_to_fill("400x400")
    |> save(path: avatar_path)
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
