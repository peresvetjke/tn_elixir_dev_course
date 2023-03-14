defmodule MyCalendar.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :login, :string
      add :email, :string

      timestamps()
    end

    alter table(:meetings) do
      add :organizator_id, references(:users)
    end
  end
end
