defmodule Snitch.Data.Schema.Payment do
  @moduledoc """
  Models a Payment
  """

  use Snitch.Data.Schema

  alias Snitch.Data.Schema.{Order, PaymentMethod}

  @type t :: %__MODULE__{}

  @payment_types ["chk", "ccd"]

  schema "snitch_payments" do
    field(:slug, :string)
    field(:payment_type, :string, size: 3)
    field(:amount, Money.Ecto.Composite.Type, default: Money.new(0, :USD))
    field(:state, :string, default: "pending")

    belongs_to(:payment_method, PaymentMethod)
    belongs_to(:order, Order)
    timestamps()
  end

  @update_fields ~w(slug state order_id)a
  @create_fields @update_fields ++ ~w(amount payment_type payment_method_id)a

  @doc """
  Returns a `Payment` changeset for a new `payment`.

  `:payment_type` is required when `action` is `:create`
  """
  @spec create_changeset(t, map) :: Ecto.Changeset.t()
  def create_changeset(%__MODULE__{} = payment, params) do
    payment
    |> cast(params, @create_fields)
    |> validate_required(@create_fields)
    |> validate_discriminator(:payment_type, @payment_types)
    |> foreign_key_constraint(:payment_method_id)
    |> common_changeset()
  end

  @doc """
  Returns a `Payment` changeset to update `payment`.

  The `:payment_type` and `amount` if provided, are simply ignored.

  Consider deleting the payment, and making a new one if you wish to "change"
  the payment type.
  """
  @spec create_changeset(t, map) :: Ecto.Changeset.t()
  def update_changeset(%__MODULE__{} = payment, params) do
    payment
    |> cast(params, @update_fields)
    |> common_changeset()
  end

  @spec common_changeset(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp common_changeset(changeset) do
    changeset
    |> foreign_key_constraint(:order_id)
    |> validate_amount(:amount)
    |> unique_constraint(:slug)
  end

  @spec validate_discriminator(Ecto.Changeset.t(), atom, list) :: Ecto.Changeset.t()
  defp validate_discriminator(%Ecto.Changeset{valid?: true} = changeset, key, permitted) do
    {_, discriminator} = fetch_field(changeset, key)

    if discriminator in permitted do
      changeset
    else
      add_error(changeset, :payment_type, "'#{discriminator}' is invalid", validation: :inclusion)
    end
  end

  defp validate_discriminator(changeset, _, _), do: changeset

  @spec validate_amount(Ecto.Changeset.t(), atom) :: Ecto.Changeset.t()
  defp validate_amount(%Ecto.Changeset{valid?: true} = changeset, key) do
    {_, amount} = fetch_field(changeset, key)

    if Decimal.cmp(amount.amount, Decimal.new(0)) != :lt do
      changeset
    else
      add_error(changeset, :amount, "must be greater than 0", validation: :amount)
    end
  end

  defp validate_amount(changeset, _), do: changeset
end
