class User
  include Mongoid::Document
  field :name, type: String
  field :provider, type: String

  validates_presence_of :name, :provider

  has_and_belongs_to_many :rooms
end