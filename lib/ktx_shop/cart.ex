defmodule KtxShop.Cart do
  @moduledoc """
  Cart Schema.

  Fields:
    - `subtotal`
    Total cart price before applying discounts

    - `total`
    Total cart price after applying discounts

    - `items`
      It's a map with format `%{product_code => quantity}`
      to store how many of each product were added to the cart
  """

  defstruct subtotal: 0, total: 0, items: %{}
  @type t() :: %__MODULE__{}
end
