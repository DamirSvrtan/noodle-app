class RoomsController < BaseController

  def create
    room = Room.new(name: params['name'], public: true)
    room.users << current_user
    room.save!
    redirect_to "/chat"
  end

  def destroy
  end
end