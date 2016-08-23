defmodule Skiptip.RidesProviderProfile do
  use Skiptip.Web, :model

  schema "rides_provider_profiles" do
    field :user_id, :integer
    field :payment_types, :string
    field :max_drive_distance, :integer
    field :rate, :integer
    field :max_seats, :integer
    field :available, :boolean, default: false

    timestamps
  end

  @required_fields ~w(user_id payment_types max_drive_distance rate max_seats available)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
