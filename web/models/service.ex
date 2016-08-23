defmodule Skiptip.Service do
  use Skiptip.Web, :model
  alias Skiptip.Service

  schema "services" do
    field :provider_id, :integer
    field :consumer_id, :integer
    field :phase, :integer
    field :kind, :integer

    has_many :messages, Skiptip.Message
    timestamps
  end

  @required_fields ~w(provider_id consumer_id phase kind)
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

  def create_ride(driver_id, rider_id, criteria) do
    {response, service} = changeset(%Service{},
      %{
        provider_id: driver_id,
        consumer_id: rider_id,
        phase: ServicePhase.pending,
        kind: ServiceKind.ride
      }
    ) |> Repo.insert

    case response do
      :ok ->
        RideCriteria.create(service.id, criteria)
        service
    end
  end
end
