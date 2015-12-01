class SshKey < ActiveRecord::Base
	belongs_to :user

	after_commit :add_key_to_related_app, on: :create
	before_destroy :delete_key_on_server

	def fingerprint
		Digest::MD5.hexdigest(decoded_key(self.key_string)).gsub(fingerprint_regex, '\1:\2')
	end

	private

		def add_key_to_related_app
			if self.created_at.eql?(self.updated_at)
				box_ids = self.user.boxes.map(&:id) + self.user.invited_boxes.map(&:id)
				AddSshKeyToApp.perform_later(self, box_ids)
			end
		end

		def delete_key_on_server
			sys_callback = system("dokku access:remove #{self.fingerprint}")
			false unless sys_callback
		end

		def decoded_key(key)
      Base64.decode64(parse_ssh_public_key(key).last)
    end

    def fingerprint_regex
      /(.{2})(?=.)/
    end

		def parse_ssh_public_key(public_key)
      raise PublicKeyError, "newlines are not permitted between key data" if public_key =~ /\n(?!$)/

      parsed = public_key.split(" ")
      parsed.each_with_index do |el, index|
        return parsed[index..(index+1)]
      end
      raise PublicKeyError, "cannot determine key type"
    end
end
