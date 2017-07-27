class ConferencePreference < ActiveRecord::Base
  belongs_to :conference_preference_info
  belongs_to :conference

  def without_conferences?(att)
    att[:conference_id].blank?
  end
end