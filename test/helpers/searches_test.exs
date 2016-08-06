defmodule Skiptip.SearchesTest do
  use ExUnit.Case

  import Ecto.Query

  alias Skiptip.Searches
  alias Skiptip.Location
  alias Skiptip.Factory
  alias Skiptip.Repo

  test 'rides search finds results in a 1 mile radius' do

    coordinates_outside_radius = [
      { 33.877037, -84.175205 },
      { 33.843556, -84.342910 },
      { 33.850882, -84.420219 },
      { 33.800412, -84.387309 },
      { 33.834653, -84.368019 },
      { 42.701682, -75.756089 },
      { 40.789109, -121.225940 },
      { 51.466390, -0.046928 }
    ]

    coordinates_inside_radius = [
      { 33.819270, -84.354294 },
      { 33.821621, -84.367422 },
      { 33.816422, -84.366687 },
      { 33.831389, -84.368080 }
    ]

    (coordinates_outside_radius ++ coordinates_inside_radius) |>
      Enum.each(fn({lat, lng}) ->
        Factory.create_user_with_location(lat, lng)
      end)

    my_coordinates = { 33.818829, -84.363795 }
    user_ids = Searches.rides(my_coordinates)

    assert user_ids

    points = Repo.all(
      from l in Location,
      select: l.point,
      where: l.user_id in ^user_ids
    )

    coordinates = Enum.map(points, fn(point) ->
      Location.latlng(point)
    end)

    assert coordinates == coordinates_inside_radius
  end

end
