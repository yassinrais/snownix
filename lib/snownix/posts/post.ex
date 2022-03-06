defmodule Snownix.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  alias Snownix.Accounts.User

  schema "posts" do
    field :description, :string
    field :poster, :string
    field :published_at, :naive_datetime
    field :slug, :string
    field :title, :string

    belongs_to :author, User, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:slug, :title, :poster, :description, :published_at])
    |> validate_required([:slug, :title, :poster, :description, :published_at])
  end
end
