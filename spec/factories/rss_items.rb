FactoryGirl.define do

  factory :rss_item, class: RSSItem do
    subject 'Test'
    newsletter
  end

end
