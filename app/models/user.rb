class User < ApplicationRecord
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  enum role: { user: 'user', admin: 'admin' }

  def admin?
    role == 'admin'
  end

  def user?
    role == 'user'
  end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
