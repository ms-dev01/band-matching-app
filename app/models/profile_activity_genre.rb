class ProfileActivityGenre < ApplicationRecord
  belongs_to :profile
  belongs_to :activity_genre
end
