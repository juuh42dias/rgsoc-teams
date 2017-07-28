require 'spec_helper'

describe ConferencePreferenceInfo, type: :model do
    it { is_expected.to belongs_to(:team) }
    it { is_expected.to have_many(:conference_preferences) }
end
