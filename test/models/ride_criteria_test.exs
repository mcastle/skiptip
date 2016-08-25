defmodule Skiptip.RideCriteriaTest do
  use Skiptip.ModelCase

  alias Skiptip.RideCriteria

  @valid_attrs %{service_id: 42}
  @invalid_attrs %{}

  @tag :skip
  test "changeset with valid attributes" do
    changeset = RideCriteria.changeset(%RideCriteria{}, @valid_attrs)
    assert changeset.valid?
  end

  @tag :skip
  test "changeset with invalid attributes" do
    changeset = RideCriteria.changeset(%RideCriteria{}, @invalid_attrs)
    refute changeset.valid?
  end
end
