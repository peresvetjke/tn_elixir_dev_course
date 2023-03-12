defmodule MyCalendar.App.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias MyCalendar.App.{Meeting, User, MeetingsUser}

  schema "users" do
    field(:login)
    field(:email)
    many_to_many(:meetings, Meeting, join_through: MeetingsUser)

    timestamps()
  end

  @spec changeset(Ecto.Schema.t(), map()) :: Ecto.Changeset.t()
  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:login, :email])
    |> validate_required([:login, :email])
    |> validate_format(:email, ~r/@/)
  end

  @spec create(list() | map()) :: {:ok, Ecto.Schema.t()} | {:error, any()}
  def create(params) when is_list(params),
    do: params |> Map.new() |> create()

  def create(params) when is_map(params) do
    %User{}
    |> changeset(params)
    |> case do
      %Ecto.Changeset{valid?: false, errors: errors} -> {:error, errors}
      changeset -> {:ok, apply_changes(changeset)}
    end
  end
end
