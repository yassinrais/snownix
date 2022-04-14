defmodule SnownixWeb.PostLive.Components.UploadComponent do
  use SnownixWeb, :live_component

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
