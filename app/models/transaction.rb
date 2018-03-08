class Transaction < ApplicationRecord
  belongs_to :bank_account
  belongs_to :category

  validates :api_transaction_id, presence: true, uniqueness: true

  include PgSearch
  pg_search_scope :search_by_description_and_category,
    against: [ :description ],
    associated_against: { category: [:name] },
    using: {
      tsearch: { prefix: true }
      # trigram: {}
    }
end
