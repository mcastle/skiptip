defmodule Skiptip.MessageTest do
  use Skiptip.ModelCase
  import Ecto.Query

  alias Skiptip.Message
  alias Skiptip.Repo
  alias Skiptip.Factory

  @valid_attrs %{}
  @invalid_attrs %{}

  test "send message" do
    user1 = Factory.create_user
    user2 = Factory.create_user
    message_body = "hello user2"

    assert Repo.one(from u in Message, select: count(u.id)) == 0
    Message.send(%{
      api_key: user1.api_key,
      user_id: user1.id,
      recipient_id: user2.id,
      body: message_body
    })
    assert Repo.one(from u in Message, select: count(u.id)) == 1

    message = Repo.one(Message)
    assert message.body == message_body
  end

  test "send message with invalid api key fails" do
    user1 = Factory.create_user
    user2 = Factory.create_user
    message_body = "hello user2"

    assert Repo.one(from u in Message, select: count(u.id)) == 0
    send_attempt = Message.send(%{
      api_key: "invalid key",
      user_id: user1.id,
      recipient_id: user2.id,
      body: message_body
    })
    assert Repo.one(from u in Message, select: count(u.id)) == 0
    assert send_attempt == :invalid_api_key
  end

end
