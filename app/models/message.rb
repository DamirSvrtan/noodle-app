class Message
  include Mongoid::Document
  
  validates_presence_of :content, :user_id

  field :content, type: String
  field :user_name, type: String

  embedded_in :room
  belongs_to :user
end