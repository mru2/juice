defmodule Juice.Soundcloud.User do

  @moduledoc """
    Structure representing a soundcloud user
  """
  defstruct [:id, :name, :track_count]

  def from_json(json) do
    %Juice.Soundcloud.User{
      id: json["id"],
      name: json["permalink"],
      track_count: json["public_favorites_count"]
    }
  end

  defimpl Inspect, for: Juice.Soundcloud.User do
    def inspect(user, opts) do
      "%User##{user.id}{ #{user.name} }"
    end
  end

end
