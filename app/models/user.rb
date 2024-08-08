class User < ApplicationRecord
    has_secure_password
    
    has_many :scores, dependent: :destroy
    has_many :cards, through: :scores
  
    validates :name, presence: true
    validates :email, presence: true, format: { with: /\S+@\S+/ }, uniqueness: { case_sensitive: false }
  end