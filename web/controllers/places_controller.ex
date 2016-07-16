defmodule Skiptip.PlacesController do
  use Skiptip.Web, :controller


  def search(conn, params) do
    filter_fun = & Map.take &1, ~w(description place_id types)
    payload = place_autocomplete(params["location"], params["query"])
      |> Map.update("predictions", [], &(Enum.map &1, filter_fun))

    render(conn, "places.json", payload: payload)
  end

  def place_autocomplete(location, query) do
    endpoint = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    params = %{
      key: "AIzaSyDulRPvOY-igDXaBEflUj7EJfhhPRW_vno",
      location: location,
      radius: 5000,
      input: query
    }
    request = Skiptip.Requests.get(endpoint, params)
    request.body |> Skiptip.Utils.to_map
  end


end
