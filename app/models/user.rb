class User < ApplicationRecord

  mount_uploader :avatar, AvatarUploader

  has_many :posts, dependent: :destroy

  has_many :friendships
  has_many :friends, through: :friendships

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :posts_visible_to, { everyone: 0, friends: 1, friends_of_friends: 2 }, suffix: true
  enum :search_visibility, { everyone: 0, friends: 1, friends_of_friends: 2 }, suffix: true
  enum :allow_invites_from, { everyone: 0, friends: 1, friends_of_friends: 2 }, suffix: true

  validates :first_name, length: { minimum: 3, maximum: 30 }
  validates :last_name, length: { minimum: 3, maximum: 30 }
  validates :dob, presence: true 
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password, length: { minimum: 8 }, on: :create

  validate :password_lower_case, on: :create
  validate :password_uppercase, on: :create
  validate :password_special_char, on: :create
  validate :password_contains_number, on: :create

  def password_uppercase
    return if !!password.match(/\p{Upper}/)
    errors.add :password, ' must contain at least 1 uppercase charachter'
  end

  def password_lower_case
    return if !!password.match(/\p{Lower}/)
    errors.add :password, ' must contain at least 1 lowercase charachter'
  end

  def password_special_char
    special = "?<>',?[]}{=@-)(*&^%$#`~{}!"
    regex = /[#{special.gsub(/./){|char| "\\#{char}"}}]/
    return if password =~ regex
    errors.add :password, ' must contain special character'
  end

  def password_contains_number
    return if password.count("0-9") > 0
    errors.add :password, ' must contain at least one number'
  end

end