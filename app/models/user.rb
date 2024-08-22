class User < ApplicationRecord
    has_secure_password
    
    has_many :scores, dependent: :destroy
    has_many :cards, through: :scores
  
    def admin?
      self.admin
    end

    attribute :admin, :boolean, default: false
    validates :name, presence: true
    validates :email, presence: true, format: { with: /\S+@\S+/ }, uniqueness: { case_sensitive: false }
  end