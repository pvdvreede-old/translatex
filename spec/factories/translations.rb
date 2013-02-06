# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :translation do
    name { Faker::Lorem.words(4) }
    description { Faker::Lorem.paragraph(3) }
    user
  end
end
