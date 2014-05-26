class OnlineUsersTracker

  @@online_users = {}

  def self.online_users
    @@online_users.values
  end

  class << self
    def []=(key, value)
      @@online_users[key] = value
    end

    def [](key)
      @@online_users[key]
    end

    def delete(key)
      @@online_users.delete(key)
    end

    def offline_users
      User.all - online_users
    end

    alias_method :remove, :delete
  end
end