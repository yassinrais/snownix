defmodule Snownix.Uploaders.MdUploader do
  use Waffle.Definition

  # To add a thumbnail version:
  @versions [:original]

  # Whitelist file extensions:
  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()

    case Enum.member?(~w(.jpg .jpeg .gif .png), file_extension) do
      true -> :ok
      false -> {:error, "invalid file type"}
    end
  end

  # Override the persisted filenames:
  def filename(version, _) do
    version
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, key}) do
    "uploads/mds/#{key}"
  end
end
