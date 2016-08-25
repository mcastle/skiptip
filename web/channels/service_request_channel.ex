defmodule Skiptip.ServiceRequestChannel do
  use Phoenix.Channel
  alias Skiptip.Driver
  alias Skiptip.Service
  alias Skiptip.Repo

  def join("service_request:ride:" <> driver_id, _payload, socket) do
    if Driver.is_available(driver_id) do
      socket = assign(socket, :driver, Repo.get(User, driver_id) )
      { :ok, socket }
    else
      { :error, %{reason: "driver is unavailable"} }
    end
  end

  def handle_in("ride_request", %{rider_id: rider_id, criteria: criteria}, socket) do
    driver = socket.assigns[ :driver ]
    if Driver.is_available(driver.id) do
      service = Service.create_ride(driver.id, rider_id, criteria)
      payload = Map.merge(criteria, %{rider_id: rider_id, service_id: service.id })
      broadcast!(socket, "ride_request", payload)
      { :reply, %{service_id: service.id}, socket }
    else
      { :error, %{reason: "driver is no longer available"} }
    end
  end

end
