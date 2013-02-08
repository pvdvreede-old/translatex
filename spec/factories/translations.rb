# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :translation do
    name { Faker::Lorem.sentence(2) }
    description { Faker::Lorem.paragraph(3) }
    user
    identifier # sequence already registered in user factory
  end
end
