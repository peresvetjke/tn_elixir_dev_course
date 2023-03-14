defmodule MyCalendar.App.MeetingTest do
  use MyCalendar.DataCase

  alias MyCalendar.App.Meeting

  @valid_attrs %{
    date_time: DateTime.new!(~D[2023-01-01], ~T[10:00:00.000], "Etc/UTC"),
    duration_minutes: 60
  }
  @invalid_attrs %{
    date_time: ~D[2023-01-01],
    duration_minutes: "60"
  }

  describe "changeset/1" do
    test "changeset with valid attributes" do
      changeset = Meeting.changeset(%Meeting{}, @valid_attrs)
      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = Meeting.changeset(%Meeting{}, @invalid_attrs)
      refute changeset.valid?
    end
  end

  describe "create/1" do
    test "create with valid attributes" do
      assert {:ok, %Meeting{}} = Meeting.create(@valid_attrs)
    end

    test "create with invalid attributes" do
      assert {:error, _} = Meeting.create(@invalid_attrs)
    end

    test "create with valid attributes (with list)" do
      assert {:ok, %Meeting{}} =
               Meeting.create(
                 date_time: DateTime.new!(~D[2023-01-01], ~T[10:00:00.000], "Etc/UTC"),
                 duration_minutes: 60
               )
    end
  end
end
