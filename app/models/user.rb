class User < ApplicationRecord
  pay_customer
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :blog_accesses, dependent: :destroy
  has_many :accessible_blogs, through: :blog_accesses, source: :blog

  enum role: { user: 0, admin: 1 }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
