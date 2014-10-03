class Post < ActiveRecord::Base
  has_and_belongs_to_many :categories, -> { uniq }, touch: true
  validates :title, :content, presence: true
  before_save :touch_categories

  def touch_categories
    categories.each(&:touch)
  end
end
