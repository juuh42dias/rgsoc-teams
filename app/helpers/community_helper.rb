module CommunityHelper
  def interests_for(user)
    return unless user.present?
    interests = user.interested_in.map {|k| User::INTERESTS[k] }.compact.join(", ")
    interest_others = user.interested_in_other
    content_tag(:p, interests) + content_tag(:p, interest_others)
  end
end