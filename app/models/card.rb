class Card < ApplicationRecord
    validates :url, presence: true, format: URI::regexp(%w[http https])
    validates :visible, inclusion: { in: [true, false] }
    
    has_many :scores, dependent: :destroy
    has_many :users, through: :scores

    after_create_commit { broadcast_append_to "cards" }
    after_update_commit { broadcast_replace_to "cards" }
    after_destroy_commit { broadcast_remove_to "cards" }

    def reveal_scores!
      update(visible: true)
    end
  
    def hide_scores!
      update(visible: false)
    end
  
    def scores_visible?
      visible
    end
  end