module ContainerStatus
	extend ActiveSupport::Concern

	included do
		include ::AASM

		# rails bugs, after_commit still firing on update :(
		# https://github.com/rails/rails/issues/14493
		after_commit :init_container, on: :create 

		aasm do
	    state :idle, initial: true 
	    state :creating
	    state :create_failed
	    state :destroying
	    state :destroy_failed
	    state :updating_component

	    # Create
	    event :create_container, after_commit: :create_container_job do
	      transitions from: [:idle, :create_failed], to: :creating
	    end
	    event :create_container_failed do
	      transitions from: :creating, to: :create_failed
	    end

	    # Destroy
	    event :destroy_container, after_commit: :delete_container_job do
	      transitions from: [:idle, :destroy_failed], to: :destroying
	    end
	    event :destroy_container_failed do
	      transitions from: :destroying, to: :destroy_failed
	    end

	    # Updating Component (just for box)
	    event :update_component do
	      transitions from: :idle, to: :updating_component
	    end

	     event :update_component_complete do
	      transitions from: :updating_component, to: :idle
	    end


	    # Complete
	    event :aasm_complete do
	      transitions from: [:creating, :destroying], to: :idle
	    end

	  end
	end

	private

		def init_container
			if self.created_at.eql?(self.updated_at)
				puts "-" * 20
				puts "Create container Job Call"
				puts "-" * 20
      	self.create_container!
      end
    end

		def create_container_job
			CreateContainerJob.perform_later(self)
		end

		def delete_container_job
			DeleteContainerJob.perform_later(self)
		end

end