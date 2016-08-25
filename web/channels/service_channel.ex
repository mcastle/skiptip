defmodule Skiptip.ServiceChannel do
  use Phoenix.Channel
  alias Skiptip.Service
  alias Skiptip.Repo

  def join("service:" <> service_id, %{user_id: user_id}, socket) do
    service = Repo.get(Service, service_id)
    socket = assign(socket, :service, service)
    if service |> Service.includes(user_id) do
      { :ok, socket }
    else
      { :error, %{reason: "service does not include this user"} }
    end
  end

  def handle_in("accept", %{driver_id: driver_id}, socket) do
    if Service.provider_is(socket.assigns[:service], driver_id) do
      # change service phase to whatever the next phase should be
    else
      { :error, %{reason: "only the service provider can accept a request"} }
    end
  end

  def handle_in("reject", %{driver_id: driver_id}, socket) do
    if Service.provider_is(socket.assigns[:service], driver_id) do
      # change service phase to rejected
    else
      { :error, %{reason: "only the service provider can reject a request"} }
    end
  end

  def handle_in("cancel", payload, socket) do
    # change service phase to cancelled
  end

  def handle_in("message", payload, socket) do
    # broadcast message to subscribes
  end

end
