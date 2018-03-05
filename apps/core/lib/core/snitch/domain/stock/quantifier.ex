defmodule Core.Snitch.Domain.Stock.Quantifier do
  @moduledoc """
    Interface for handling inventory related business logic
  """

  use Core.Snitch.Domain

  @doc """
    Returns a `total available inventory count` for stockt items
    present in all active stock locations only.
  """
  @spec total_on_hand(Core.Snitch.Variant.t()) :: non_neg_integer()
  def total_on_hand(variant) when is_map(variant), do: total_on_hand(variant.id)
  @spec total_on_hand(non_neg_integer()) :: non_neg_integer()
  def total_on_hand(variant_id) when is_integer(variant_id) do
    Model.Stock.StockItem.total_on_hand(variant_id)
  end
end