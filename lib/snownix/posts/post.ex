defmodule Snownix.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  import Snownix.Helper

  @primary_key {:id, :binary_id, autogenerate: true}

  alias Snownix.Accounts.User
  alias Snownix.Posts.Entity

  schema "posts" do
    field :description, :string
    field :poster, :string
    field :published_at, :naive_datetime
    field :slug, :string
    field :title, :string
    field :read_time, :integer

    belongs_to :author, User, type: :binary_id
    has_many :entities, Entity

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    attrs = Map.merge(attrs, generate_slug(attrs))

    post
    |> cast(attrs, [:slug, :title, :poster, :description, :published_at, :author_id, :entities])
    |> validate_required([:slug, :title, :poster, :description, :published_at])
    |> unique_constraint(:slug)
    |> cast_assoc(:entities)
  end
end
