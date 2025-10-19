class Project < ApplicationRecord
    belongs_to :author, class_name: "User"
    has_many :memberships, as: :memberable, as: :memberable, :dependent => :destroy
    has_many :users, through: :memberships
end
