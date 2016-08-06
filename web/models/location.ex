defmodule Skiptip.Location do
  use Skiptip.Web, :model

  schema "locations" do
    field :user_id, :integer
    field :point, Geo.Point

    timestamps
  end

  @required_fields ~w(user_id)
  @optional_fields ~w(point)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def update(model, lat, lng) do
    # longitude and latitude is reversed
    coordinates = {lng, lat}
    # The World Geodetic System srid is 4326
    wgs84_srid = 4326
    geo = %Geo.Point{coordinates: coordinates, srid: wgs84_srid}
    updated_location = changeset(model, %{point: geo})
    Skiptip.Repo.update!(updated_location)
  end

  def point(lat, lng), do: %Geo.Point{coordinates: {lng, lat}}
  def point({lat, lng}), do: %Geo.Point{coordinates: {lng, lat}}

  def latlng(%Geo.Point{coordinates: {lng, lat}}), do: {lat, lng}
  def latlng(%Skiptip.Location{point: point}), do: latlng(point)


end
