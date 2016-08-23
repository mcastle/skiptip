defmodule Skiptip.SearchesTest do
  use ExUnit.Case

  import Ecto.Query

  alias Skiptip.Searches
  alias Skiptip.Location
  alias Skiptip.Factory
  alias Skiptip.Repo

  @user_coordinates { 33.818829, -84.363795 }

  @coordinates_inside_radius [
    { 33.819270, -84.354294 },
    { 33.821621, -84.367422 },
    { 33.816422, -84.366687 },
    { 33.831389, -84.368080 }
  ]

  @coordinates_outside_radius [
    { 33.877037, -84.175205 },
    { 33.843556, -84.342910 },
    { 33.850882, -84.420219 },
    { 33.800412, -84.387309 },
    { 33.834653, -84.368019 },
    { 42.701682, -75.756089 },
    { 40.789109, -121.225940 },
    { 51.466390, -0.046928 }
  ]


  test 'rides search finds results in a 1 mile radius' do
    create_users_with_locations @coordinates_outside_radius
    users = create_users_with_locations @coordinates_inside_radius
    user_ids = Searches.rides(@user_coordinates)
    assert user_ids == Enum.map(users, &(&1.id))
  end

  test "rides search excludes unavailable ride providers" do
    {unavailable_locations, locations} = Enum.split(@coordinates_inside_radius, 2)
    create_users_with_locations(unavailable_locations, false)
    users = create_users_with_locations(locations)
    user_ids = Searches.rides(@user_coordinates)
    assert user_ids == Enum.map(users, &(&1.id))
  end

  defp create_users_with_locations(coordinate_list, available \\ true) do
    Enum.map(coordinate_list, fn(coordinates) ->
      [
        { :location, %{point: Location.point(coordinates) } },
        { :rides_provider_profile, %{ available: available } }
      ] |> Factory.create_user
    end)
  end

  defp all_coordinates, do: @coordinates_inside_radius ++ @coordinates_outside_radius

end
