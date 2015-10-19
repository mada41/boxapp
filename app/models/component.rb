class Component < ActiveRecord::Base
  belongs_to :box

  validates :name, uniqueness: true

  before_create :set_name
  after_create :create_dokku_component
  after_destroy :delete_dokku_component

  private

    def set_name
      self.name = "#{self.box.id}#{Time.now.to_i}"
    end

    def create_dokku_component
      case self.type
      when 'Components::Database'
        Rails.logger.info `dokku #{self.c_type}:create #{self.name}`
      end
    end

    def delete_dokku_component
      case self.type
      Rails.logger.info self.type
      when 'Components::Database'
        Rails.logger.info `yes #{self.name} | dokku #{self.c_type}:destroy #{self.name}`
        Rails.logger.info self.type
      end
    end

end
