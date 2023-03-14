defmodule MyCalendar.App.MeetingsUser do
  use Ecto.Schema

  schema "meetings_users" do
    field(:user_id, :integer)
    field(:meeting_id, :integer)

    timestamps()
  end
end
