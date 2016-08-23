defmodule Skiptip.ServiceTest do
  use Skiptip.ModelCase

  import Ecto.Query
  alias Skiptip.Location
  alias Skiptip.Factory
  alias Skiptip.Service
  alias Skiptip.RideCriteria
  alias Skiptip.ServicePhase
  alias Skiptip.ServiceKind

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

  test "create_ride creates service with associated ride_criteria" do
    ride_criteria_cs = %{
      origin: Location.point(30, 30),
      destination: Location.point(40, 40),
      seat_count: 3,
      rate: 100
    }
    driver = Factory.create_user
    rider = Factory.create_user

    service = Service.create_ride(driver.id, rider.id, ride_criteria_cs)
    assert service.driver_id == driver.id
    assert service.rider_id == rider.id
    assert service.kind == ServiceKind.ride
    assert service.phase == ServicePhase.pending

    ride_criteria = Repo.one(from rc in RideCriteria, where: rc.service_id == ^service.id)
    assert ride_criteria.origin.coordinates == ride_criteria_cs.origin.coordinates
    assert ride_criteria.destination.coordinates == ride_criteria_cs.destination.coordinates
    assert ride_criteria.seat_count == ride_criteria_cs.seat_count
    assert ride_criteria.rate == ride_criteria_cs.rate
    assert ride_criteria.pickup_time == nil
    assert ride_criteria.dropoff_time == nil
  end
end
