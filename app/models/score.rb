class Score < ApplicationRecord
  belongs_to :user
  belongs_to :card

  validates :user_id, uniqueness: { scope: :card_id, message: "has already scored this card" }
end