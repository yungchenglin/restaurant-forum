# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  role                   :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  intro                  :text
#  avatar                 :string
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :comments
  has_many :restaurants, through: :comments
  
  mount_uploader :avatar, AvatarUploader
  
  # 使用者有很多收藏的餐廳的多對多關聯
  has_many :favorites, dependent: :destroy # 當 User 物件被刪件，相關的 Favorite 物件會一併刪除
  has_many :favorited_restaurants, through: :favorites, source: :restaurant
  
  # 使用者有很多喜翻的餐廳的多對多關聯
  has_many :likes, dependent: :destroy # 當 User 物件被刪件，相關的 Favorite 物件會一併刪除
  has_many :liked_restaurants, through: :likes, source: :restaurant
  
  has_many :followships, dependent: :destroy
  has_many :followings, through: :followships
  
  def admin?
    self.role == 'admin'
  end
end
