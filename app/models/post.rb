class Post < ActiveRecord::Base
  belongs_to :user

  has_many :comments, dependent: :destroy

  validates :user_id, presence: true
  validates :type, presence: true
  #validates :title, presence: true

  def cached_comment_count
    Rails.cache.fetch [self, "comment_count"] do
      comments.size
    end
  end

  # def as_json( options = {} )
  #   #super(only: [:id, :title])
  #   #super(except: [:user_id], include: [:user, :comments])
  #   super(except: [:user_id], include: :user, methods: :cached_comment_count)
  # end
end
