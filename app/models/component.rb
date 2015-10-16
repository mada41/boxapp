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

end
