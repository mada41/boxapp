class Component < ActiveRecord::Base
  include ContainerStatus
  
  belongs_to :box

  validates :c_type, presence: true

  before_create :set_init_data

  private

    def get_info
      cmd = `dokku #{self.c_type}:info #{self.name}`
      cmd.gsub("\n", '').gsub('DSN:', '').strip
    end

    def set_init_data
      self.name = "#{self.box.id}-#{Time.now.to_i}" unless self.name
    end

end
