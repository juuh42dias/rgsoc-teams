# frozen_literal_string: true

# nodoc
class ConferencePreferenceInfo < ApplicationRecord
  # validates :conference_id, presence: true
  # validates :condition_term_ticket presence: true
  # validates :condition_term_cost presence: true
  # before_save :accepted_conditions?

  belongs_to :team
  has_many :conference_preferences
  accepts_nested_attributes_for :conference_preferences,
                                allow_destroy: true,
                                reject_if: :without_conferences?

  def with_preferences_build
    conference_preferences.build(option: 1) unless conference_preferences.find_by(option: 1)
    conference_preferences.build(option: 2) unless conference_preferences.find_by(option: 2)
  end

  def without_conferences?(att)
    att[:conference_id].blank?
  end

  # def accepted_conditions?
  #   return false if condition_term_ticket.blank? && condition_term_cost.blank?
  #   errors.add(:base, 'Accept terms and conditions is necessary')
  # end
end
