class ConferencePreferenceInfo < ApplicationRecord
  belongs_to :team
  has_many :conference_preferences

  accepts_nested_attributes_for :conference_preferences, allow_destroy: true#, reject_if: :without_conferences?

  def with_preferences_build
    conference_preferences.build(option: 1) unless conference_preferences.find_by(option: 1)
    conference_preferences.build(option: 2) unless conference_preferences.find_by(option: 2)
  end

  def without_conferences?(att)
    att[:conference_id].blank?
  end
end