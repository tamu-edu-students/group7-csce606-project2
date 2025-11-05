class Project < ApplicationRecord
    belongs_to :author, class_name: "User"
    has_many :memberships, as: :memberable, dependent: :destroy
    has_many :users, through: :memberships
    validates :title, :description, :skills, presence: true

    has_many :pending_memberships, -> { where(status: :pending) }, as: :memberable, class_name: "Membership"
    has_many :approved_memberships, -> { where(status: :approved) }, as: :memberable, class_name: "Membership"



    def open?
        status == "open"
    end

    def closed?
        status == "closed"
    end
end
