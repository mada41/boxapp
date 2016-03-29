class User < ActiveRecord::Base
  include CleanChildren
  include DeviseTokenAuth::Concerns::User
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable

  has_many :boxes # no dependent destroy, see include CleanChildren concern model
  has_many :ssh_keys, dependent: :destroy

  has_and_belongs_to_many :invited_boxes, class_name: 'Box', join_table: 'boxes_users'
end
