# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :translation do
    name { Faker::Lorem.sentence(2) }
    description { Faker::Lorem.paragraph(3) }
    user
    identifier # sequence already registered in user factory
    api_key_enabled false
    basic_auth_enabled false

    trait :with_api_key do
      api_key_enabled true
      api_key { Faker::Lorem.word }
    end

    trait :with_basic_auth do
      basic_auth_enabled true
      basic_auth_username { Faker::Internet.user_name }
      basic_auth_password { Faker::Lorem.word }
    end

    factory :translation_with_api_key, :traits => [:with_api_key]
    factory :translation_with_basic_auth, :traits => [:with_basic_auth]
    factory :translation_with_all_security,
      :traits => [:with_api_key, :with_basic_auth]
  end
end
