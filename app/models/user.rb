class User < ApplicationRecord
    has_many :projects, inverse_of: :author, dependent: :destroy
    has_many :teaching_offers,  inverse_of: :author, dependent: :destroy
    has_many :bulletin_posts,  inverse_of: :author, dependent: :destroy

    has_many :memberships, dependent: :destroy
    has_many :joined_projects, through: :memberships, source: :memberable, source_type: 'Project'
    has_many :joined_teaching_offers, through: :memberships, source: :memberable, source_type: 'TeachingOffer'

    has_many :notifications, dependent: :destroy
end
