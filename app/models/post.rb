class Post < ApplicationRecord
    mount_uploader :media, MediaUploader

    belongs_to :user

    validates :text, length: { minimum: 3, maximum: 255 }
end
