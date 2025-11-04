require "amatch"
include Amatch

class BulletinPost < ApplicationRecord
    belongs_to :author, class_name: "User"
end
