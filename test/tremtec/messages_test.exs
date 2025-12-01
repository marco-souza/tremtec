defmodule Tremtec.MessagesTest do
  use Tremtec.DataCase, async: true

  alias Tremtec.Messages
  alias Tremtec.Messages.ContactMessage

  def contact_message_fixture(attrs \\ %{}) do
    default_attrs = %{
      name: "Jane",
      email: "jane@example.com",
      message: String.duplicate("hello world ", 2)
    }

    {:ok, msg} = Messages.create_contact_message(Map.merge(default_attrs, attrs))
    msg
  end

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

  describe "list_admin_messages/2" do
    test "returns paginated messages excluding deleted" do
      msg1 = contact_message_fixture()
      msg2 = contact_message_fixture()
      msg3 = contact_message_fixture()

      # Soft delete one message
      {:ok, _deleted_msg} = Messages.delete_admin_message(msg2)

      {messages, total} = Messages.list_admin_messages(1, 10)

      assert Enum.count(messages) == 2
      assert total == 2
      assert Enum.any?(messages, fn m -> m.id == msg1.id end)
      assert Enum.any?(messages, fn m -> m.id == msg3.id end)
      refute Enum.any?(messages, fn m -> m.id == msg2.id end)
    end

    test "handles pagination correctly" do
      _msg1 = contact_message_fixture()
      _msg2 = contact_message_fixture()
      _msg3 = contact_message_fixture()

      {messages_page1, _total} = Messages.list_admin_messages(1, 2)
      {messages_page2, _total} = Messages.list_admin_messages(2, 2)

      assert Enum.count(messages_page1) == 2
      assert Enum.count(messages_page2) == 1
    end
  end

  describe "search_admin_messages/1" do
    test "searches messages by name" do
      msg1 = contact_message_fixture(%{name: "John Doe"})
      _msg2 = contact_message_fixture(%{name: "Jane Smith"})

      results = Messages.search_admin_messages("John")

      assert Enum.count(results) >= 1
      assert Enum.any?(results, fn m -> m.id == msg1.id end)
    end

    test "searches messages by email" do
      msg1 = contact_message_fixture(%{email: "john@example.com"})
      _msg2 = contact_message_fixture(%{email: "jane@example.com"})

      results = Messages.search_admin_messages("john@example.com")

      assert Enum.any?(results, fn m -> m.id == msg1.id end)
    end

    test "searches messages by content" do
      msg1 = contact_message_fixture(%{message: "I need help with project X"})
      _msg2 = contact_message_fixture(%{message: "Another message"})

      results = Messages.search_admin_messages("project X")

      assert Enum.any?(results, fn m -> m.id == msg1.id end)
    end

    test "excludes soft deleted messages" do
      msg1 = contact_message_fixture(%{name: "Test"})
      _msg2 = contact_message_fixture(%{name: "Test"})

      {:ok, _deleted_msg} = Messages.delete_admin_message(msg1)

      results = Messages.search_admin_messages("Test")

      refute Enum.any?(results, fn m -> m.id == msg1.id end)
    end
  end

  describe "mark_message_read/2" do
    test "marks message as read" do
      msg = contact_message_fixture()
      assert msg.read == false

      {:ok, updated_msg} = Messages.mark_message_read(msg, true)

      assert updated_msg.read == true
    end

    test "marks message as unread" do
      msg = contact_message_fixture(%{message: "test message"})
      {:ok, _msg} = Messages.mark_message_read(msg, true)

      fetched_msg = Messages.get_contact_message!(msg.id)
      {:ok, updated_msg} = Messages.mark_message_read(fetched_msg, false)

      assert updated_msg.read == false
    end
  end

  describe "delete_admin_message/1" do
    test "soft deletes a message" do
      msg = contact_message_fixture()

      {:ok, deleted_msg} = Messages.delete_admin_message(msg)

      assert deleted_msg.deleted_at != nil
      # Verify the message is not in the list
      {messages, _total} = Messages.list_admin_messages(1, 100)
      refute Enum.any?(messages, fn m -> m.id == msg.id end)
    end

    test "soft deleted message cannot be found in normal queries" do
      msg = contact_message_fixture()
      Messages.delete_admin_message(msg)

      {messages, total} = Messages.list_admin_messages(1, 100)
      assert total == 0
      assert Enum.empty?(messages)
    end
  end

  describe "count_unread_messages/0" do
    test "counts unread messages" do
      _msg1 = contact_message_fixture()
      msg2 = contact_message_fixture()
      _msg3 = contact_message_fixture()

      # Mark some as read
      Messages.mark_message_read(msg2, true)

      unread_count = Messages.count_unread_messages()

      assert unread_count == 2
    end

    test "excludes soft deleted messages" do
      msg1 = contact_message_fixture()
      _msg2 = contact_message_fixture()

      Messages.delete_admin_message(msg1)

      unread_count = Messages.count_unread_messages()

      assert unread_count == 1
    end
  end

  describe "get_last_message_date/0" do
    test "returns the date of the last message" do
      _msg = contact_message_fixture()

      last_date = Messages.get_last_message_date()

      refute is_nil(last_date)
    end

    test "returns nil when no messages exist" do
      last_date = Messages.get_last_message_date()

      assert is_nil(last_date)
    end

    test "excludes soft deleted messages" do
      msg1 = contact_message_fixture()
      msg2 = contact_message_fixture()

      # Delete the most recent
      Messages.delete_admin_message(msg2)

      last_date = Messages.get_last_message_date()

      assert last_date == msg1.inserted_at
    end
  end
end
