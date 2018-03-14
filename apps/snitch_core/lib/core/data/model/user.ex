defmodule Snitch.Data.Model.User do
  @moduledoc """
  User API
  """
  use Snitch.Data.Model
  alias Snitch.Data.Schema.User

  @spec create(map) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create(params) do
    QH.create(User, params, Repo)
  end

  @spec get(map | non_neg_integer) :: User.t() | nil
  def get(query_fields_or_primary_key) do
    QH.get(User, query_fields_or_primary_key, Repo)
  end

  @spec get_all() :: [User.t()]
  def get_all(), do: Repo.all(User)
end
