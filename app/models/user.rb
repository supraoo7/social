class User < ActiveRecord::Base
  has_many :subscriptions, foreign_key: :follower_id, dependent: :destroy
  has_many :leaders, through: :subscriptions

  has_many :reverse_subscriptions, foreign_key: :leader_id, class_name: 'Subscription', dependent: :destroy
  has_many :followers, through: :reverse_subscriptions

  has_many :posts, dependent: :destroy
  has_many :text_posts, dependent: :destroy
  has_many :image_posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  # validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  # api token
  validates :api_token, presence: true, uniqueness: true
  before_validation :generate_api_token

  has_secure_password

  def following?(leader)
    leaders.include? leader
  end

  def follow!(leader)
    if leader != self && !following?(leader)
      leaders << leader
    end
  end

  def timeline_user_ids
    leader_ids + [id]
  end

  def generate_api_token
    return if api_token.present?

    loop do
      self.api_token = SecureRandom.hex
      # keep looping until this api token is unique to prevent duplicates (edge case, chances are slim generated api token is a duplicate )
      break unless User.exists?(api_token: api_token)
    end
  end
end
