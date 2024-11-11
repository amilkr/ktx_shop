defmodule KtxShopTest do
  use ExUnit.Case

  @ets_table KtxShop.Products

  describe "add_products_to_cart/2" do
    setup do
      :ok =
        Application.put_env(:ktx_shop, :products, [
          %{code: "GR1", name: "Green tea", price: "3.11", discount_code: :buy_one_get_one},
          %{code: "SR1", name: "Strawberries", price: "5.00", discount_code: :drop_to_four_fifty},
          %{code: "CF1", name: "Coffee", price: "11.23", discount_code: :drop_to_two_thirds},
          %{code: "WT1", name: "Water", price: "1.50", discount_code: nil}
        ])

      :ok = KtxShop.seed()
    end

    test "it adds products to a cart updating its total price (applying the discounts)" do
      # Create carts using the test data defined in the 'Technical evaluation' documentation
      cart1 = KtxShop.add_products_to_cart(["GR1", "SR1", "GR1", "GR1", "CF1"])
      cart2 = KtxShop.add_products_to_cart(["GR1", "GR1"])
      cart3 = KtxShop.add_products_to_cart(["SR1", "SR1", "GR1", "SR1"])
      cart4 = KtxShop.add_products_to_cart(["GR1", "CF1", "SR1", "CF1", "CF1"])

      # Verify the total price on each cart
      assert cart1.total == Decimal.new("22.45")
      assert cart2.total == Decimal.new("3.11")
      assert cart3.total == Decimal.new("16.61")
      assert cart4.total == Decimal.new("30.57")

      # Create an extra cart with products without discounts
      cart5 = KtxShop.add_products_to_cart(["WT1", "WT1", "WT1", "WT1"])

      # Verify that the total is equal to the subtotal
      assert cart5.total == cart5.subtotal
      assert cart5.total == Decimal.new("6.00")
    end

    test "it ignores product codes that doesn't exist in the system" do
      # Adding INVALID_CODE to an empty cart
      cart = KtxShop.add_products_to_cart(["INVALID_CODE"])

      # The cart remains empty
      assert cart.items == %{}
      assert cart.total == 0

      # Adding INVALID_CODE to a cart with 1 item
      cart = %KtxShop.Cart{}
      cart = KtxShop.add_products_to_cart(cart, ["GR1"])
      cart = KtxShop.add_products_to_cart(cart, ["INVALID_CODE"])

      # The cart keeps only the valid item
      assert cart.items == %{"GR1" => 1}
      assert cart.total == Decimal.new("3.11")

      # Mixing INVALID_CODE with valid codes
      cart = KtxShop.add_products_to_cart(["GR1", "INVALID_CODE", "CF1"])

      # The cart keeps only the valid items
      assert cart.items == %{"GR1" => 1, "CF1" => 1}
      assert cart.total == Decimal.new("14.34")
    end
  end

  describe "seed/0" do
    setup do
      config_product = %{code: "TEST1", name: "Test Product", price: "5.00", discount_code: nil}
      :ok = Application.put_env(:ktx_shop, :products, [config_product])

      %{config_product: config_product}
    end

    test "loads products from the config to an ets table", ctx do
      expected_product = struct(KtxShop.Product, ctx.config_product)

      # The ets table doesn't exist yet
      assert :undefined = :ets.info(@ets_table, :name)

      # Call the function
      :ok = KtxShop.seed()

      # The ets table exist now. And it contains the product defined in the config.
      assert @ets_table = :ets.info(@ets_table, :name)
      assert [{expected_product.code, expected_product}] == :ets.tab2list(@ets_table)
    end
  end
end
