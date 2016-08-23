defmodule Skiptip.ServiceTest do
  use Skiptip.ModelCase

  alias Skiptip.Service
  alias Skiptip.Factory

  @valid_attrs %{ provider_id: 42, phase: 42, consumer_id: 42, kind: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Service.changeset(%Service{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Service.changeset(%Service{}, @invalid_attrs)
    refute changeset.valid?
  end
end
