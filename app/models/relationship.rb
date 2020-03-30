class Relationship < ApplicationRecord

  #active_relationshipが従属するモデル
  belongs_to :follower, class_name: "User"
  
  #passive_relationsipsが従属するモデル
  belogns_to :following, class_name: "User"
  
  validates :follower_id, presence: true
  validates :following_id, presence: true
end
