class Message
  include Mongoid::Document
  
  validates_presence_of :content, :user_id

  field :content
  embedded_in :room
  belongs_to :user
end