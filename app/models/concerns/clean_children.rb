module CleanChildren
	extend ActiveSupport::Concern

	included do
		after_destroy :clean_children_job
	end


	private
	  def clean_children_job
	  	CleanChildrenJob.perform_later(self.class.name, self.id)
	  end
end