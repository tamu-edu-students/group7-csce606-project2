class User < ApplicationRecord
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    has_many :projects, inverse_of: :author, dependent: :destroy
    has_many :teaching_offers,  inverse_of: :author, dependent: :destroy
    has_many :bulletin_posts,  inverse_of: :author, dependent: :destroy

    has_many :memberships, dependent: :destroy
    has_many :joined_projects, through: :memberships, source: :memberable, source_type: "Project"
    has_many :joined_teaching_offers, through: :memberships, source: :memberable, source_type: "TeachingOffer"

    has_many :notifications, dependent: :destroy

    validates :name, presence: true
    validates :email, presence: true,
                        format: { with: /\A[\w+\-.]+@tamu\.edu\z/i, message: "must be a tamu.edu email" }
    validates :password, length: { minimum: 8 },
                     format: { with: /\A(?=.*[0-9!@#$%^&*]).+\z/,
                               message: "must include at least one number or special character" },
                     if: -> { password.present? }
end
