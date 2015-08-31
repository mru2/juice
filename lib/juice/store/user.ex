defmodule Juice.Store.User do
  @primary_key {:id, :id, autogenerate: false}

  use Ecto.Model

  schema "users" do
    field :name
    field :track_count, :integer
  end
end
