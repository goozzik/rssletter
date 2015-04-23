FactoryGirl.define do

  factory :rss_item, class: RSSItem do
    title 'Test'
    content 'content'
    newsletter
  end

end
