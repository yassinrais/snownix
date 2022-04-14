defmodule Snownix.Posts.Entity do
  use Ecto.Schema
  import Ecto.Changeset

  alias Snownix.Posts.Post

  schema "posts_entities" do
    field :tmp_id, :binary_id, virtual: true

    field :body, :string
    field :type, :string, default: "text"
    field :order, :integer, default: 0

    belongs_to :post, Post, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(entity, attrs) do
    entity
    |> cast(attrs, [:body, :order, :type, :post_id])
    |> validate_required([:body, :order, :type])
  end
end
