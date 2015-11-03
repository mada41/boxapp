class Box < ActiveRecord::Base
  attr_accessor :core_system

  belongs_to :user
  has_many :components, dependent: :destroy

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true

  before_create :dokku_creation
  before_destroy :dokku_deletion

  private

    def dokku_creation
      create_dokku_app = system("dokku apps:create #{self.slug}")
      self.errors.add(:core_system, 'creating app failed') unless create_dokku_app
      # system("dokku postgres:link #{db.name} #{self.slug}")
    end

    def dokku_deletion
      destroy_dokku_app = system("yes #{self.slug} | dokku apps:destroy #{self.slug}")
      raise 'deleting app failed' unless destroy_dokku_app
    end
end
