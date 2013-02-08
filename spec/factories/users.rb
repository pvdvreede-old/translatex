FactoryGirl.define do
  sequence(:email) { |n| "user@user#{n}.com" }
  sequence(:identifier) { |n| "ident#{n}" }

  factory :user do
    email
    password "test1212"
    confirmed_at { Time.now }
    identifier

    factory :unconfirmed_user do
      confirmed_at nil
    end
  end
end
