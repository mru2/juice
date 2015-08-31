defmodule Juice.Store.Like do
  use Ecto.Model

  schema "likes" do
    field :user_id, :integer
    field :track_id, :integer    
  end
end
