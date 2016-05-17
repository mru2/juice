defmodule Juice.Store.User do
  @primary_key {:id, :id, autogenerate: false}

  use Ecto.Model

  schema "users" do
    field :display, :string
    field :track_count, :integer
    field :meta, :map
    timestamps
  end
end
