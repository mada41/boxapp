class Box < ActiveRecord::Base
  belongs_to :user

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true

  after_create :create_dokku_app
  after_destroy :destroy_dokku_app

  private

    def create_dokku_app
      system `dokku create #{self.slug}`
    end

    def destroy_dokku_app
      system `dokku delete #{self.slug}`
    end
end
