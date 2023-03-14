defmodule MyCalendar.Repo.Migrations.CreateMeetingsUsers do
  use Ecto.Migration

  def change do
    create table(:meetings_users) do
      add :meeting_id, references(:meetings)
      add :user_id, references(:users)

      timestamps()
    end
  end
end
