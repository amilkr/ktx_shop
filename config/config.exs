import Config

config :ktx_shop,
  products: [
    %{code: "GR1", name: "Green tea", price: "3.11", discount_code: :buy_one_get_one},
    %{code: "SR1", name: "Strawberries", price: "5.00", discount_code: :drop_to_four_fifty},
    %{code: "CF1", name: "Coffee", price: "11.23", discount_code: :drop_to_two_thirds}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
