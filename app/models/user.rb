# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  comments_count         :integer
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  likes_count            :integer
#  private                :boolean
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #validates(:poster, { :presence => true })

  # Association accessor methods to define:

  ## Direct associations

  # Photo#poster: returns a row from the users table associated to this photo by the owner_id column
  belongs_to(:poster, class_name: "User", foreign_key: "owner_id")

  # Photo#comments: returns rows from the comments table associated to this photo by the photo_id column
  has_many(:comments, class_name: "Comment", foreign_key: "photo_id")

  # Photo#likes: returns rows from the likes table associated to this photo by the photo_id column
  has_many(:likes, class_name: "Like", foreign_key: "photo_id")

  ## Indirect associations

  # Photo#fans: returns rows from the users table associated to this photo through its likes
  has_many(:fans, through: :likes, source: :fan)
end
