defmodule MyCalendar.App.Meeting do
  use Ecto.Schema

  import Ecto.Changeset

  alias MyCalendar.App.{Meeting, User, MeetingsUser}

  schema "meetings" do
    field(:date_time, :utc_datetime)
    field(:duration_minutes, :integer)
    belongs_to(:organizator, User)
    many_to_many(:users, User, join_through: MeetingsUser)

    timestamps()
  end

  @spec changeset(Ecto.Schema.t(), map()) :: Ecto.Changeset.t()
  def changeset(meeting, params \\ %{})

  def changeset(meeting, %{} = params) do
    meeting
    |> cast(params, [:date_time, :duration_minutes])
    |> validate_required([:date_time, :duration_minutes])
  end

  @spec create(any()) :: {:ok, Ecto.Schema.t()} | {:error, any()}
  def create(params) when is_list(params),
    do: params |> Map.new() |> create()

  def create(params) when is_map(params) do
    %Meeting{}
    |> changeset(params)
    |> case do
      %Ecto.Changeset{valid?: false, errors: errors} -> {:error, errors}
      changeset -> {:ok, apply_changes(changeset)}
    end
  end
end
