defmodule MyCalendar.App.UserTest do
  use MyCalendar.DataCase

  alias MyCalendar.App.User

  @valid_attrs %{login: "username", email: "username@example.com"}
  @invalid_attrs %{login: "username@example.com", email: "username"}

  describe "changeset/2" do
    test "changeset with valid attributes" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert changeset.valid?
    end

    test "changeset with invalid attributes" do
      changeset = User.changeset(%User{}, @invalid_attrs)
      refute changeset.valid?
    end
  end

  describe "create/1" do
    test "create with valid attributes" do
      assert {:ok, %User{}} = User.create(@valid_attrs)
    end

    test "create with invalid attributes" do
      assert {:error, _} = User.create(@invalid_attrs)
    end

    test "create with valid attributes (with list)" do
      assert {:ok, %User{}} = User.create(login: "username", email: "username@example.com")
    end
  end
end
