defmodule Skiptip.RidesProviderProfileTest do
  use Skiptip.ModelCase

  alias Skiptip.RidesProviderProfile

  @valid_attrs %{available: true, max_drive_distance: 42, max_seats: 42, payment_types: "some content", rate: 42, user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = RidesProviderProfile.changeset(%RidesProviderProfile{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = RidesProviderProfile.changeset(%RidesProviderProfile{}, @invalid_attrs)
    refute changeset.valid?
  end
end
