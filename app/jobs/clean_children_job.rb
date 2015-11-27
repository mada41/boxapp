class CleanChildrenJob < ActiveJob::Base
  queue_as :default

  def perform(tipe, parent_id)
  	if tipe.eql? 'User'
  		children = Box.where(user_id: parent_id).first
  	else
  		children = Component.where(box_id: parent_id).first
  	end

    children.destroy_container! if children
  end
end
