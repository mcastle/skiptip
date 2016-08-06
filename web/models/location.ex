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

  def update(model, lat, lon) do
    geo = %Geo.Point{coordinates: {lat, lon}}
    updated_location = changeset(model, %{point: geo})
    Skiptip.Repo.update!(updated_location)
  end
end
