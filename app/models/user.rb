# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  attr_reader :password

  validates :username, :session_token, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  before_validation :ensure_session_token

  def self.generate_session_token
    SecureRandom::urlsafe_base64
  end

  def self.find_by_credentials(user_name, pass)
    user = User.find_by(username: user_name)
    return nil if user.nil?
    user.is_password?(pass) ? user : nil
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  def password=(pass)
    @password = pass
    self.password_digest = BCrypt::Password.create(pass)
  end

  def is_password?(pass)
    BCrypt::Password.new(self.password_digest).is_password?(pass)
  end

  has_many :cats,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: :Cat

  has_many :rental_requests,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: :CatRentalRequest

  private

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

end
