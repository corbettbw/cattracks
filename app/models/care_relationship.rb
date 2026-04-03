class CareRelationship < ApplicationRecord
  belongs_to :user
  belongs_to :cat

  after_create :check_colony_guardian

  private

  def check_colony_guardian
    if user.cats.count >= 5
      user.award_badge("Colony Guardian")
    end
  end
end
