FactoryBot.define do
  factory :to_do do
    after :create do |todo|
      create_list :line_item, 3, to_do: todo
    end
  end
end
