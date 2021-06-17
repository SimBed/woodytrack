class Problem < ApplicationRecord
  has_many :relationship_ps, dependent: :destroy
  has_many :users, through: :relationship_ps
  validates :name,  presence: true, length: { maximum: 26 },
                    uniqueness: { case_sensitive: false }
end
