class Room
  include Mongoid::Document
  field :name, type: String
  field :public, type: Boolean

  validates_presence_of :name

  has_and_belongs_to_many :users
  embeds_many :messages

  def self.default_room
    find_by(name: "DefaultRoom")
  end

  def self.find_or_create_private_conversation(first_user_id, second_user_id)
    room_name = private_conversation_name(first_user_id, second_user_id)
    Room.where(name: room_name, public: false).first_or_create
  end

  def self.private_conversation_name(first_user_id, second_user_id)
    if first_user_id > second_user_id
      "#{first_user_id}_#{second_user_id}"
    else
      "#{second_user_id}_#{first_user_id}"
    end
  end
end