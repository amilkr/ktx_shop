defmodule KtxShop do
  @moduledoc """
  Application API.
  """

  @doc """
  Adds the given product_codes to the given cart (by default, an empty cart).
  After adding the products, it updates the total cart price and returns the updated cart.

  The cart.total field stores the total cart price (after applying discounts).
  Check the KtxShop.Cart module for more details about cart fields.

  ## Examples
      iex> cart = KtxShop.add_products_to_cart(["SR1", "GR1"])
        %KtxShop.Cart{
          subtotal: Decimal.new("8.11"),
          total: Decimal.new("8.11"),
          items: %{"GR1" => 1, "SR1" => 1}

      iex> cart = KtxShop.add_products_to_cart(cart, ["CF1", "GR1", "CF1"])
        %KtxShop.Cart{
          subtotal: Decimal.new("33.68"),
          total: Decimal.new("30.57"),
          items: %{"CF1" => 2, "GR1" => 2, "SR1" => 1}
        }
  """
  @spec add_products_to_cart(KtxShop.Cart.t(), [String.t()]) :: KtxShop.Cart.t()
  def add_products_to_cart(cart \\ %KtxShop.Cart{}, product_codes) do
    KtxShop.Carts.add_products(cart, product_codes)
  end

  @doc """
  Loads the initial products into the system.

  In a real-life application the products would be stored and fetched from a DB,
  so this step would not be necessary during the application startup (but a seed script
  could exist to generate records in the DB before starting the application).
  """
  @spec seed() :: :ok
  def seed, do: KtxShop.Products.seed()
end
