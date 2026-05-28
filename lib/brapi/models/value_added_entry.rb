# frozen_string_literal: true

module Brapi
  module Models
    # Demonstração do Valor Adicionado (DVA).
    class ValueAddedEntry < Brapi::Model
      attribute :type, type: :string
      attribute :end_date, type: :string
      attribute :revenue
      attribute :product_sales
      attribute :other_revenues
      attribute :construction_of_own_assets
      attribute :provision_or_reversal_of_doubtful_accounts
      attribute :supplies_purchased_from_third_parties
      attribute :costs_with_products_sold
      attribute :third_party_materials_and_services
      attribute :loss_or_recovery_of_assets
      attribute :other_supplies
      attribute :gross_added_value
      attribute :retentions
      attribute :depreciation_and_amortization
      attribute :other_retentions
      attribute :net_added_value
      attribute :net_added_value_produced
      attribute :added_value_received_on_transfer
      attribute :added_value_received_by_transfer
      attribute :equity_income_result
      attribute :financial_income
      attribute :other_values_received_on_transfer
      attribute :other_values_received_by_transfer
      attribute :added_value_to_distribute
      attribute :total_added_value_to_distribute
      attribute :distribution_of_added_value
      attribute :team_remuneration
      attribute :taxes
      attribute :federal_taxes
      attribute :state_taxes
      attribute :municipal_taxes
      attribute :remuneration_of_third_party_capitals
      attribute :equity_remuneration
      attribute :own_equity_remuneration
      attribute :interest_on_own_equity
      attribute :dividends
      attribute :retained_earnings_or_loss
      attribute :non_controlling_share_of_retained_earnings
      attribute :other_distributions
      attribute :financial_intermediation_revenue
      attribute :revenue_from_the_provision_of_services
      attribute :provision_or_reversal_of_expected_credit_risk_losses
      attribute :financial_intermediation_expenses
      attribute :materials_energy_and_others
      attribute :services
      attribute :loss_or_recovery_of_asset_values
      attribute :third_party_equity_remuneration
      attribute :insurance_operations_revenue
      attribute :complementary_pension_operations_revenue
      attribute :fees_revenue
      attribute :variations_of_technical_provisions
      attribute :insurance_operations_variations
      attribute :pension_operations_variations
      attribute :other_variations
      attribute :net_operating_revenue
      attribute :claims_and_benefits
      attribute :variation_in_deferred_selling_expenses
      attribute :results_of_ceded_reinsurance_operations
      attribute :result_of_coinsurance_operations_assigned
    end
  end
end
