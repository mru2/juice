defmodule Juice.Store.Repo.Migrations.CreateSchema do
  use Ecto.Migration

  def change do
    create table(:tracks, primary_key: false) do
      add :id, :integer, primary_key: true, autogenerate: false
      add :display, :string
      add :user_count, :integer
      add :meta, :json

      timestamps()
    end

    create table(:users, primary_key: false) do
      add :id, :integer, primary_key: true, autogenerate: false
      add :display, :string
      add :track_count, :integer
      add :meta, :json

      timestamps()
    end

    create table(:likes) do
      add :track_id, :integer
      add :user_id, :integer
    end

    create unique_index(:likes, [:track_id, :user_id])
  end
end
