defmodule Snownix.Navigation.Menu do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "menus" do
    field :parent_id, :binary_id

    field :title, :string
    field :link, :string

    field :newtab, :boolean, default: false
    field :status, :string, default: "active"

    timestamps()
  end

  @doc false
  def changeset(menu, attrs) do
    menu
    |> cast(attrs, [:parent_id, :title, :link, :newtab, :status])
    |> validate_required([:title, :link, :newtab, :status])
  end
end
