class Box < ActiveRecord::Base
  include ContainerStatus
  include CleanChildren

  belongs_to :user
  has_many :components # no dependent destroy, see include CleanChildren concern model

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true
end
