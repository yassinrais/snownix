defmodule Snownix.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :slug, :string
      add :title, :text
      add :poster, :text
      add :description, :text
      add :published_at, :naive_datetime

      add :author_id, :uuid

      timestamps()
    end
  end
end
