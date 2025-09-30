defmodule Tremtec.MessagesTest do
  use Tremtec.DataCase, async: true

  alias Tremtec.Messages
  alias Tremtec.Messages.ContactMessage

  test "create_contact_message/1 persists valid data" do
    attrs = %{
      name: "Jane",
      email: "jane@example.com",
      message: String.duplicate("hello world ", 2)
    }

    assert {:ok, %ContactMessage{} = msg} = Messages.create_contact_message(attrs)
    assert msg.id
    assert msg.read == false
  end

  test "list_contact_messages/1 returns inserted messages" do
    {:ok, msg} =
      Messages.create_contact_message(%{
        name: "A",
        email: "a@b.com",
        message: String.duplicate("x", 10)
      })

    [found] = Messages.list_contact_messages()
    assert found.id == msg.id
  end
end
