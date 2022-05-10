defmodule Snownix.Posts.Category do
  use Ecto.Schema
  import Ecto.Changeset
  import Snownix.Helper

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "categories" do
    field :slug, :string
    field :title, :string
    field :description, :string
    field :status, :string, default: "active"

    field :parent_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    attrs = Map.merge(attrs, generate_slug(attrs))

    category
    |> cast(attrs, [:slug, :title, :description, :status])
    |> unique_constraint(:slug)
    |> validate_required([:slug, :title, :status])
  end
end
