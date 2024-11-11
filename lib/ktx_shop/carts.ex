defmodule KtxShop.Carts do
  @moduledoc """
  Context to manage carts.
  """

  require Logger

  alias KtxShop.Cart
  alias KtxShop.Discounts
  alias KtxShop.Products

  @doc """
  Adds the given product codes to the given cart (by default, an empty cart).
  After adding the products, it updates the total cart price and returns the updated cart.
  """
  @spec add_products(Cart.t(), [String.t()]) :: Cart.t()
  def add_products(cart, product_codes) do
    cart
    |> update_items(product_codes)
    |> update_totals()
  end

  ## Private Functions

  # It increases the counter (quantity) for the given cart items matching the given product_codes.
  # If the product code doesn't exist in the system, it doesn't update the cart.
  # If the product code is not present in the items map, the function initializes it with `counter=1`.
  defp update_items(cart, product_codes) do
    Enum.reduce(product_codes, cart, fn product_code, cart ->
      if Products.exists?(product_code) do
        items = Map.update(cart.items, product_code, 1, fn quantity -> quantity + 1 end)
        struct(cart, %{items: items})
      else
        Logger.warning("Invalid product code: #{inspect(product_code)}")
        cart
      end
    end)
  end

  # It loops through the cart items calculating their subtotal and total,
  # to update the cart's subtotal and total.
  #
  # The subtotal price for each item is calculated by doing `product.price * quantity`.
  # The total price for each item is calculated
  # by calling `Discounts.apply_discount(product, quantity)`.
  defp update_totals(cart) do
    # Reset subtotal and total
    cart = struct(cart, %{subtotal: 0, total: 0})

    Enum.reduce(cart.items, cart, fn {product_code, quantity}, cart ->
      product = Products.get!(product_code)

      item_subtotal = Decimal.mult(product.price, quantity)
      item_total = Discounts.apply_discount(product, quantity)

      struct(cart, %{
        subtotal: Decimal.add(cart.subtotal, item_subtotal),
        total: Decimal.add(cart.total, item_total)
      })
    end)
  end
end
