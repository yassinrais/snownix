defmodule Snownix.Helper do
  def generate_slug(params) do
    case !is_nil(params[:title]) do
      true ->
        %{slug: Slug.slugify(params[:title])}

      false ->
        %{}
    end
  end
end
