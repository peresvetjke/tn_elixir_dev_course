defmodule MyCalendar.AppTest do
  use MyCalendar.DataCase

  alias MyCalendar.App

  # users

  @valid_attrs %{login: "username", email: "username@example.com"}
  @invalid_attrs %{login: "username@example.com", email: "username"}

  describe "get_user/1" do
    test "returns user when exists" do
      {:ok, user} = App.create_user(@valid_attrs)
      assert user == App.get_user(user.id)
    end

    test "returns nil when does not exist" do
      {:ok, user} = App.create_user(@valid_attrs)
      App.delete_user(user)
      refute App.get_user(user.id)
    end
  end

  test "list_users/0" do
    {:ok, user1} = App.create_user(%{login: "username1", email: "username1@example.com"})
    {:ok, user2} = App.create_user(%{login: "username2", email: "username2@example.com"})
    assert App.list_users() == [user1, user2]
  end

  describe "create_user/1" do
    test "creates user with valid params" do
      {:ok, user} = App.create_user(@valid_attrs)
      assert user == App.get_user(user.id)
    end

    test "returns error with invalid params" do
      {:error, _} = App.create_user(@invalid_attrs)
      assert App.list_users() == []
    end
  end

  describe "update_user/1" do
    test "updates user with valid params" do
      {:ok, user} = App.create_user(@valid_attrs)

      assert {:ok, _} =
               App.update_user(user, %{login: "new_login", email: "new_email@example.com"})

      updated_user = App.get_user(user.id)
      assert updated_user.login == "new_login"
      assert updated_user.email == "new_email@example.com"
    end

    test "returns error with invalid params" do
      {:ok, user} = App.create_user(@valid_attrs)
      assert {:error, _} = App.update_user(user, %{login: "new_login", email: "wrong_email"})
    end
  end

  test "delete_user/1" do
    {:ok, user} = App.create_user(@valid_attrs)
    assert App.get_user(user.id) == user
    {:ok, _} = App.delete_user(user)
    refute App.get_user(user.id)
  end

  # meetings

  describe "get_meeting/1" do
    test "returns meeting when exists" do
      organizator = %MyCalendar.App.User{login: "username", email: "username@example.com"}

      attrs = %{
        date_time: DateTime.new!(~D[2023-01-01], ~T[10:00:00.000], "Etc/UTC"),
        duration_minutes: 60
      }

      {:ok, meeting} = MyCalendar.App.create_meeting(organizator, attrs)
      assert meeting == MyCalendar.App.get_meeting(meeting.id)
      assert meeting.organizator.login == organizator.login
      assert meeting.organizator.email == organizator.email
    end

    test "returns nil when does not exist" do
      organizator = %MyCalendar.App.User{login: "username", email: "username@example.com"}

      attrs = %{
        date_time: DateTime.new!(~D[2023-01-01], ~T[10:00:00.000], "Etc/UTC"),
        duration_minutes: 60
      }

      {:ok, meeting} = App.create_meeting(organizator, attrs)
      App.delete_meeting(meeting)
      refute App.get_meeting(meeting.id)
    end
  end

  test "list_meetings/0" do
    {:ok, organizator} = App.create_user(%{login: "username", email: "username@example.com"})

    attrs1 = %{
      date_time: DateTime.new!(~D[2023-01-01], ~T[10:00:00.000], "Etc/UTC"),
      duration_minutes: 60
    }

    attrs2 = %{
      date_time: DateTime.new!(~D[2023-01-02], ~T[11:00:00.000], "Etc/UTC"),
      duration_minutes: 120
    }

    {:ok, meeting1} = App.create_meeting(organizator, attrs1)
    {:ok, meeting2} = App.create_meeting(organizator, attrs2)
    assert App.list_meetings() == [meeting1, meeting2]
  end

  describe "create_meeting/1" do
    test "creates meeting with valid params" do
      organizator = %MyCalendar.App.User{login: "username", email: "username@example.com"}

      user1 = %MyCalendar.App.User{login: "username1", email: "username1@example.com"}
      user2 = %MyCalendar.App.User{login: "username2", email: "username2@example.com"}

      attrs = %{
        date_time: DateTime.new!(~D[2023-01-01], ~T[10:00:00.000], "Etc/UTC"),
        duration_minutes: 60
      }

      {:ok, meeting} = App.create_meeting(organizator, attrs, [user1, user2])
      assert meeting == App.get_meeting(meeting.id)
      assert meeting.organizator.login == "username"

      assert Enum.map(meeting.users, fn u -> u.login end) ==
               Enum.map([user1, user2], fn u -> u.login end)
    end

    test "returns error with invalid params" do
      organizator = %MyCalendar.App.User{login: "username", email: "username@example.com"}

      attrs = %{
        date_time: DateTime.new!(~D[2023-01-01], ~T[10:00:00.000], "Etc/UTC"),
        duration_minutes: "sixty"
      }

      {:error, _} = App.create_meeting(organizator, attrs)
      assert App.list_meetings() == []
    end
  end

  describe "update_meeting/1" do
    test "updates meeting with valid params" do
      organizator = %MyCalendar.App.User{login: "username", email: "username@example.com"}

      attrs = %{
        date_time: DateTime.new!(~D[2023-01-01], ~T[10:00:00], "Etc/UTC"),
        duration_minutes: 60
      }

      {:ok, meeting} = App.create_meeting(organizator, attrs)

      new_attrs = %{
        date_time: DateTime.new!(~D[2023-01-02], ~T[11:00:00], "Etc/UTC"),
        duration_minutes: 120
      }

      user1 = %MyCalendar.App.User{login: "username1", email: "username1@example.com"}
      user2 = %MyCalendar.App.User{login: "username2", email: "username2@example.com"}
      new_users = [user1, user2]

      assert {:ok, _} = App.update_meeting(meeting, new_attrs, new_users)

      updated_meeting = App.get_meeting(meeting.id)

      assert updated_meeting.date_time ==
               DateTime.new!(~D[2023-01-02], ~T[11:00:00], "Etc/UTC")

      assert updated_meeting.duration_minutes == 120

      assert Enum.map(updated_meeting.users, fn u -> u.login end) ==
               Enum.map(new_users, fn u -> u.login end)
    end

    test "returns error with invalid params" do
      organizator = %MyCalendar.App.User{login: "username", email: "username@example.com"}

      attrs = %{
        date_time: DateTime.new!(~D[2023-01-01], ~T[10:00:00], "Etc/UTC"),
        duration_minutes: 60
      }

      {:ok, meeting} = App.create_meeting(organizator, attrs)

      assert {:error, _} =
               App.update_meeting(meeting, %{
                 date_time: DateTime.new!(~D[2023-01-02], ~T[11:00:00], "Etc/UTC"),
                 duration_minutes: nil
               })
    end
  end

  test "delete_meeting/1" do
    organizator = %MyCalendar.App.User{login: "username", email: "username@example.com"}

    attrs = %{
      date_time: DateTime.new!(~D[2023-01-01], ~T[10:00:00], "Etc/UTC"),
      duration_minutes: 60
    }

    {:ok, meeting} = App.create_meeting(organizator, attrs)
    assert App.get_meeting(meeting.id) == meeting
    {:ok, _} = App.delete_meeting(meeting)
    refute App.get_meeting(meeting.id)
  end

  test "get_meetings_by_date/1" do
    organizator = %MyCalendar.App.User{login: "username", email: "username@example.com"}

    {:ok, meeting1} =
      App.create_meeting(organizator, %{
        date_time: DateTime.new!(~D[2023-01-01], ~T[10:00:00], "Etc/UTC"),
        duration_minutes: 60
      })

    {:ok, _meeting2} =
      App.create_meeting(organizator, %{
        date_time: DateTime.new!(~D[2023-01-02], ~T[10:00:00], "Etc/UTC"),
        duration_minutes: 120
      })

    date = Date.from_iso8601!("2023-01-01")

    assert App.get_meetings_by_date(date) == [meeting1]
  end

  test "get_meetings_by_organizator_id/1" do
    {:ok, organizator1} = App.create_user(%{login: "username1", email: "username1@example.com"})
    {:ok, organizator2} = App.create_user(%{login: "username2", email: "username2@example.com"})

    {:ok, meeting1} =
      App.create_meeting(organizator1, %{
        date_time: DateTime.new!(~D[2023-01-01], ~T[10:00:00], "Etc/UTC"),
        duration_minutes: 60
      })

    {:ok, _meeting2} =
      App.create_meeting(organizator2, %{
        date_time: DateTime.new!(~D[2023-01-02], ~T[10:00:00], "Etc/UTC"),
        duration_minutes: 120
      })

    assert App.get_meetings_by_organizator_id(organizator1.id) == [meeting1]
  end

  test "get_meetings_by_user_id/1" do
    organizator = %MyCalendar.App.User{login: "username", email: "username@example.com"}

    {:ok, user1} = App.create_user(%{login: "username1", email: "username1@example.com"})
    {:ok, user2} = App.create_user(%{login: "username2", email: "username2@example.com"})

    {:ok, meeting1} =
      App.create_meeting(
        organizator,
        %{
          date_time: DateTime.new!(~D[2023-01-01], ~T[10:00:00], "Etc/UTC"),
          duration_minutes: 60
        },
        [user1]
      )

    {:ok, meeting2} =
      App.create_meeting(
        organizator,
        %{
          date_time: DateTime.new!(~D[2023-01-02], ~T[10:00:00], "Etc/UTC"),
          duration_minutes: 120
        },
        [user1, user2]
      )

    {:ok, _meeting3} =
      App.create_meeting(
        organizator,
        %{
          date_time: DateTime.new!(~D[2023-01-03], ~T[10:00:00], "Etc/UTC"),
          duration_minutes: 180
        },
        [user2]
      )

    assert App.get_meetings_by_user_id(user1.id) == [meeting1, meeting2]
  end
end
