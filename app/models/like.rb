class Like < ApplicationRecord
  belongs_to :user
  belongs_to :blog
  validates :value, inclusion: { in: [1, -1] }
end
