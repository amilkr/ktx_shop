defmodule KtxShop.Product do
  @moduledoc """
  Product Schema
  """

  defstruct [:code, :name, :price, :discount_code]
  @type t() :: %__MODULE__{}
end
