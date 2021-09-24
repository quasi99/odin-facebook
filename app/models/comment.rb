class Comment < ApplicationRecord
	include ActionView::Helpers::DateHelper
  include ElapsedTime

  belongs_to :author, class_name: :User
  belongs_to :commentable, polymorphic: true
  has_many :comments,
    as: :commentable,
    dependent: :destroy

  has_many :likes,
    as: :likable,
    dependent: :destroy

  validates :body, presence: true

  def history
    simple_elapsed_time(created_at)
  end

  def get_post_or_photo_id
    parent = commentable
    parent = parent.commentable while parent.class == Comment
    parent.id
  end
  
  def unnested_commentable_id
    if commentable.class == Comment
      commentable.commentable_id
    else
      commentable_id
    end
  end

  def get_placeholder
    if commentable.class == Comment
      "Reply to #{commentable.author.name}..."
    else
      'Write a comment...'
    end
  end
end
