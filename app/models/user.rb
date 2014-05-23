require 'active_record'
require 'mysql2' # or 'pg' or 'sqlite3'
require 'pry'

ActiveRecord::Base.establish_connection(
  adapter:  'mysql2',
  host:     'localhost',
  database: 'noodle_db',
  username: 'root'
)

unless ActiveRecord::Base.connection.table_exists? :users
  ActiveRecord::Migration.class_eval do
    create_table :users do |t|
      t.string :name
      t.string :provider
    end
  end
end

class User < ActiveRecord::Base
  validates_presence_of :name, :provider
end