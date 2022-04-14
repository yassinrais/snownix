defmodule Snownix.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :slug, :string
      add :title, :text
      add :poster, :text
      add :description, :text
      add :draft, :boolean
      add :read_time, :integer, default: 0

      add :published_at, :naive_datetime

      add :author_id, references(:users, on_delete: :nothing, type: :uuid)

      timestamps()
    end

    create index(:posts, [:slug], unique: true)
  end
end
