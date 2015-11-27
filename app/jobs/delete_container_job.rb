class DeleteContainerJob < ActiveJob::Base
  queue_as :default

  def perform(obj)
    if obj.class.eql? Box
	    system_callback = system("yes #{obj.slug} | dokku apps:destroy #{obj.slug}")
	  else
	  	system_callback = component_method(obj)
	  end

	  if system_callback
      obj.destroy
      check_parent_exist?(obj)
    else
      obj.destroy_container_failed!
    end
  end

  def component_method(obj)
    system_callback = nil

    if Box.exists? obj.box_id
      obj.box.update_component!
      system("dokku #{obj.c_type}:unlink #{obj.name} #{obj.box.slug}")
      obj.box.update_component_complete!
    end
    system_callback = system("yes #{obj.name} | dokku #{obj.c_type}:destroy #{obj.name}")

    system_callback
  end

  # Delete sibling one per one if parent destroyed
  def check_parent_exist?(obj)
    if obj.class.eql? Box
      unless User.exists? obj.user_id
        box = Box.where(user_id: obj.user_id).where.not(id: obj.id).first
        box.destroy_container! if box
      end
    else
      unless Box.exists? obj.box_id
        component = Component.where(box_id: obj.box_id).where.not(id: obj.id).first
        component.destroy_container! if component
      end
    end
  end
end
