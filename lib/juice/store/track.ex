defmodule Juice.Store.Track do
  @primary_key {:id, :id, autogenerate: false}

  use Ecto.Model

  schema "tracks" do
    field :title
    field :artist
    field :user_count, :integer
  end
end
