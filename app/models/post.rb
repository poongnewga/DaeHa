class Post < ApplicationRecord
  def self.search(search)
  where("p_message LIKE ?", "%#{search}%")
  end
end
