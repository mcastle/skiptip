defmodule Skiptip.RideCriteriaTest do
  use Skiptip.ModelCase

  alias Skiptip.RideCriteria

  @valid_attrs %{service_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = RideCriteria.changeset(%RideCriteria{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = RideCriteria.changeset(%RideCriteria{}, @invalid_attrs)
    refute changeset.valid?
  end
end
