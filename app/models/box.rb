class Box < ActiveRecord::Base
  belongs_to :user
  has_many :components, dependent: :destroy

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true

  after_create :create_dokku_app, :create_dokku_default_db
  after_destroy :destroy_dokku_app

  private

    def create_dokku_app
      Rails.logger.info `dokku apps:create #{self.slug}`
    end

    def create_dokku_default_db
      db = self.components.create(c_type: 'postgres', type: 'Components::Database')
      Rails.logger.info `dokku postgres:link #{db.name} #{self.slug}`
    end

    def destroy_dokku_app
      Rails.logger.info `yes #{self.slug} | dokku apps:destroy #{self.slug}`
    end
end
