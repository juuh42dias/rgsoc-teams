require 'spec_helper'

describe ConferencePreferenceInfo, type: :model do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to have_many(:conference_preferences) }

  describe '#with_preferences_build' do
    let(:conference_preference_info) { FactoryGirl.create(:conference_preference_info) }

    it 'should build a conference_preferences' do
      expect(conference_preference_info.with_preferences_build).to be true
    end
  end 
end
