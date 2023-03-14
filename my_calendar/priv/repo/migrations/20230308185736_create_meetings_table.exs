defmodule MyCalendar.Repo.Migrations.CreateMeetingsTable do
  use Ecto.Migration

  def change do
    create table(:meetings) do
      add :date_time, :utc_datetime
      add :duration_minutes, :integer

      timestamps()
    end
  end
end
