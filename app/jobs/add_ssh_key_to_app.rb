class AddSshKeyToApp < ActiveJob::Base
  queue_as :default

  def perform(ssh, box_ids)
  	boxes = Box.find(box_ids)
  	boxes.each do |box|
  		system "echo '#{ssh.key_string}' | dokku deploy:allow #{box.slug}"
  	end
  end
end
