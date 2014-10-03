class Post < ActiveRecord::Base
  has_and_belongs_to_many :categories, -> { uniq }
  validates :title, :content, presence: true
end
