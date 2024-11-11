defmodule KtxShop.Discounts do
  @moduledoc """
  Discounts Context.
  """

  @doc """
  Returns the total price after applying the discount
  defined in the given product for the given quantity.
  """
  @spec apply_discount(KtxShop.Product.t(), pos_integer()) :: Decimal.t()
  def apply_discount(product, quantity) do
    apply_discount(product.discount_code, product, quantity)
  end

  ## Private Functions

  defp apply_discount(nil, product, quantity) do
    Decimal.mult(product.price, quantity)
  end

  defp apply_discount(:buy_one_get_one, product, quantity) do
    {int, rem} = Decimal.div_rem(quantity, 2)
    multiplier = Decimal.add(int, rem)
    Decimal.mult(product.price, multiplier)
  end

  defp apply_discount(:drop_to_four_fifty, product, quantity) do
    if quantity >= 3 do
      # Since the documentation says "the price should drop to £4.50",
      # I'm just using 4.50 as the product price.
      # I guess that in a real-life application,
      # the expected behavior would be to reduce the price by 0.50
      Decimal.mult("4.50", quantity)
    else
      Decimal.mult(product.price, quantity)
    end
  end

  defp apply_discount(:drop_to_two_thirds, product, quantity) do
    if quantity >= 3 do
      product.price
      |> Decimal.mult(quantity)
      |> Decimal.mult(2)
      |> Decimal.div(3)
    else
      Decimal.mult(product.price, quantity)
    end
  end
end
