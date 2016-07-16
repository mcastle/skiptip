defmodule Skiptip.PlacesControllerTest do
  use Skiptip.ConnCase
  alias Skiptip.PlacesController

  test "place_autocomplete" do
    location = "33.819251,-84.365075"
    query = "fountain"
    autocomplete_response = PlacesController.place_autocomplete(location, query)
    %{"predictions" => predictions, "status" => status} = autocomplete_response
    assert status == "OK"
    assert predictions |> Enum.count == 5
  end

end
