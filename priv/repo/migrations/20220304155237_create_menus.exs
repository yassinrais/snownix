defmodule Snownix.Repo.Migrations.CreateMenus do
  use Ecto.Migration

  def change do
    create table(:menus, primary_key: false) do
      add :id, :uuid, primary_key: true

      add :parent_id, :uuid

      add :title, :text
      add :link, :text
      add :newtab, :boolean, default: false, null: false
      add :status, :string

      timestamps()
    end
  end
end
