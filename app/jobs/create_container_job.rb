class CreateContainerJob < ActiveJob::Base
  queue_as :default

  def perform(obj)
    system_callback = nil

  	if obj.class.eql? Box
	    system_callback = system("dokku apps:create #{obj.slug}")
	  else
	  	system_callback = component_method(obj)
	  end

	  if system_callback
      system("dokku ps:scale #{obj.slug}") if obj.class.eql? Box
      obj.aasm_complete!
    else
      obj.create_container_failed!
    end
  end

  def component_method(obj)
		system_callback = nil
    obj.box.update_component!

    system_callback = system("dokku #{obj.c_type}:create #{obj.name}")

    if system_callback
      system "dokku #{obj.c_type}:link #{obj.name} #{obj.box.slug}"
    end

    obj.box.update_component_complete!

  	system_callback
  end
end
