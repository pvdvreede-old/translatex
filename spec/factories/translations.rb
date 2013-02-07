# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:identifier) { |n| "ident#{n}" }

  factory :translation do
    name { Faker::Lorem.sentence(2) }
    description { Faker::Lorem.paragraph(3) }
    user
    identifier
  end
end
