class Message
  include Mongoid::Document
  
  validates_presence_of :content, :user_id

  field :content, type: String
  field :user_name, type: String

  embedded_in :room
  belongs_to :user

  def angular_hash
    { user_name: user_name, message: content, user_id: user_id }
  end
end