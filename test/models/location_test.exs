defmodule Skiptip.LocationTest do
  use Skiptip.ModelCase

  alias Skiptip.Location
  alias Skiptip.Repo
  alias Skiptip.Factory

  @valid_attrs %{user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Location.changeset(%Location{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Location.changeset(%Location{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "update with coordinates includes point" do
    user = Factory.create_user |> Repo.preload(:location)
    refute user.location.point
    user.location |> Location.update(90, 120)
    assert Repo.get(Location, user.location.id).point.coordinates == { 90, 120 }
  end
end
