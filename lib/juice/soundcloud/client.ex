defmodule Juice.Soundcloud.Client do

  @moduledoc """
    Client for the SoundCloud HTTP API
    Initialized with an API key. Handle requests throttling
  """

  use GenServer

  @endpoint "https://api.soundcloud.com"

  # Client API
  def start_link(client_id, opts \\ []) do
    GenServer.start_link(__MODULE__, client_id, opts)
  end

  # Cannot call it get since it is a method defined by HTTPoison
  def fetch(pid, path, params \\ []) do
    GenServer.call(pid, {:get, path, params})
  end

  # Server API
  def init(client_id) do
    # HTTPoison needs to be started manually somewhere
    {:ok, _} = HTTPoison.start
    {:ok, client_id}
  end

  def handle_call({:get, path, params}, _from, client_id) do
    response = client_id
    |> process_url({path, params})
    |> HTTPoison.get
    |> process_response

    # TODO : sleep until next allowed call
    {:reply, response, client_id}
  end

  # Helpers
  defp process_url(client_id, {path, params}) do
    params = [{:client_id, client_id} | params]
    querystring = URI.encode_query( params )
    @endpoint <> path <> "?" <> querystring
  end

  # Sucessful response
  defp process_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Poison.decode(body)
  end

  # Not found
  defp process_response({:ok, %HTTPoison.Response{status_code: 404}}), do: {:error, :not_found}

  # Unauthorized
  defp process_response({:ok, %HTTPoison.Response{status_code: 401}}), do: {:error, :wrong_client_id}

  # Throttled
  defp process_response({:ok, %HTTPoison.Response{status_code: 429}}), do: {:error, :too_many_requests}

  # Other errors
  defp process_response(_), do: {:error, :unknown_error}

end
