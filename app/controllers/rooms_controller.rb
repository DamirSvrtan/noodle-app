class RoomsController < BaseController

  def create
    room = Room.new(name: params['name'])
    room.users << current_user
    room.save!
    redirect_to "/"
  end

  def destroy
  end
end