class Relationship < ApplicationRecord

  =begin(active_relationship)=end belongs_to :follower, class_name: "User"
  =begin(passive_relationship)=end belogns_to :following, class_name: "User"
  
  validates :follower_id, presence: true
  validates :following_id, presence: true
end
