class Room
  include Mongoid::Document
  field :name, type: String
  field :description, type: String
  
  validates_presence_of :name, :provider

  has_and_belongs_to_many :users
  embeds_many :messages
end