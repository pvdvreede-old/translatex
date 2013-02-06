FactoryGirl.define do
  sequence(:email) { |n| "user@user#{n}.com" }

  factory :user do
    email
    password "test1212"
    confirmed_at { Time.now }
  end
end
