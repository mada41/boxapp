class Component < ActiveRecord::Base
  attr_accessor :core_system

  belongs_to :box

  validates :name, :type, :c_type, presence: true
  validates :name, uniqueness: true

  before_validation :set_type, :component_creation
  before_destroy :component_deletion

  private

    def set_type
      case
      when (['postgres'].include? self.c_type)
        self.type = 'Components::Database'
      end
    end

    def component_creation
      self.name = "#{self.box.id}#{Time.now.to_i}"

      case self.type
      when 'Components::Database'
        create_component = system("dokku #{self.c_type}:create #{self.name}")
        system "dokku #{self.c_type}:link #{self.name} #{self.box.slug}" if create_component
      end

      errors.add(:core_system, 'creating component failed') unless create_component
    end

    def component_deletion
      case self.type
      when 'Components::Database'
        system "dokku #{self.c_type}:unlink #{self.name} #{self.box.slug}"
        delete_component = system("yes #{self.name} | dokku #{self.c_type}:destroy #{self.name}")
      end

      raise 'deleting component failed' unless delete_component
    end

end
