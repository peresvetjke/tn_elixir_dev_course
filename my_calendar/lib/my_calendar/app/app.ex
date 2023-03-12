defmodule MyCalendar.App do
  alias MyCalendar.App.{Meeting, User, MeetingsUser}
  alias MyCalendar.Repo

  import Ecto.Changeset, only: [put_assoc: 3]
  import Ecto.Query, only: [from: 2]

  @spec get_user(non_neg_integer()) :: Ecto.Schema.t() | nil
  def get_user(id) do
    User
    |> Repo.get(id)
  end

  @spec get_meeting(non_neg_integer()) :: Ecto.Schema.t()
  def get_meeting(id) do
    Meeting
    |> Repo.get(id)
    |> Repo.preload([:organizator, :users])
  end

  @spec get_meetings_by_date(Date.t()) :: list(Ecto.Schema.t())
  def get_meetings_by_date(date) do
    from(m in Meeting, where: fragment("cast(? as date)", m.date_time) == ^date)
    |> Repo.all()
    |> Repo.preload([:organizator, :users])
  end

  @spec get_meetings_by_organizator_id(non_neg_integer()) :: list(Ecto.Schema.t())
  def get_meetings_by_organizator_id(organizator_id) do
    from(m in Meeting, where: m.organizator_id == ^organizator_id)
    |> Repo.all()
    |> Repo.preload([:organizator, :users])
  end

  @spec get_meetings_by_user_id(non_neg_integer()) :: list(Ecto.Schema.t())
  def get_meetings_by_user_id(user_id) do
    from(m in Meeting,
      join: mu in MeetingsUser,
      on: mu.meeting_id == m.id and mu.user_id == ^user_id
    )
    |> Repo.all()
    |> Repo.preload([:organizator, :users])
  end

  @spec list_users() :: list(Ecto.Schema.t())
  def list_users, do: Repo.all(User)

  @spec list_meetings() :: list(Ecto.Schema.t())
  def list_meetings do
    Meeting
    |> Repo.all()
    |> Repo.preload([:organizator, :users])
  end

  @spec create_user(map()) :: {:ok, Ecto.Schema.t()} | {:error, any()}
  def create_user(%{} = attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @spec create_meeting(Ecto.Schema.t(), map(), list(Ecto.Schema.t())) ::
          {:ok, Ecto.Schema.t()} | {:error, any()}
  def create_meeting(%User{} = organizator, %{} = attrs, users \\ []) do
    %Meeting{}
    |> Meeting.changeset(attrs)
    |> put_assoc(:organizator, organizator)
    |> put_assoc(:users, users)
    |> Repo.insert()
  end

  @spec update_user(Ecto.Schema.t(), map()) :: {:ok, Ecto.Schema.t()} | {:error, any()}
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @spec update_meeting(Ecto.Schema.t(), map()) :: {:ok, Ecto.Schema.t()} | {:error, any()}
  def update_meeting(%Meeting{} = meeting, attrs) do
    meeting
    |> Meeting.changeset(attrs)
    |> Repo.update()
  end

  @spec update_meeting(Ecto.Schema.t(), map(), list(Ecto.Schema.t())) ::
          {:ok, Ecto.Schema.t()} | {:error, any()}
  def update_meeting(%Meeting{} = meeting, attrs, users) do
    meeting
    |> Meeting.changeset(attrs)
    |> put_assoc(:users, users)
    |> Repo.update()
  end

  @spec delete_user(Ecto.Schema.t()) :: {:ok, Ecto.Schema.t()} | {:error, any()}
  def delete_user(%User{} = user) do
    user
    |> Repo.delete()
  end

  @spec delete_meeting(Ecto.Schema.t()) :: {:ok, Ecto.Schema.t()} | {:error, any()}
  def delete_meeting(%Meeting{} = meeting) do
    meeting
    |> Repo.delete()
  end
end
