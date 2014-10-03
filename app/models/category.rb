class Category < ActiveRecord::Base
  has_and_belongs_to_many :posts, -> { uniq }
  validates :name, presence: true
  validates :name, uniqueness: true
  before_save :touch_posts

  def touch_posts
    posts.each(&:touch)
  end
end
