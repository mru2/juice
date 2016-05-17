defmodule Juice.Store.Track do
  @primary_key {:id, :id, autogenerate: false}

  use Ecto.Model

  schema "tracks" do
    field :display, :string
    field :user_count, :integer
    field :meta, :map
    timestamps
  end
end
