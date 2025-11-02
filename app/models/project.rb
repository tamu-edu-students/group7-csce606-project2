class Project < ApplicationRecord
    belongs_to :author, class_name: "User"
    has_many :memberships, as: :memberable, dependent: :destroy
    has_many :users, through: :memberships
    validates :title, :description, :skills, presence: true

    def open?
    status == "open"
    end

    def closed?
    status == "closed"
    end
end
