defmodule SnownixWeb.PostLive.Components.EntityComponent do
  use SnownixWeb, :live_component

  defp get_body(entity) do
    Earmark.as_html!(entity.body || "")
  end
end
