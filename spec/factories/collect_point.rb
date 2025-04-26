FactoryBot.define do
  factory :collect_point0, class: 'CollectPoint' do
    name { 'Collect Point Area1' }
    coordinates { [-53.59063720703125, -15.180744171142578] }
  end

  factory :collect_point1, class: 'CollectPoint' do
    name { 'Collect Point Area 2' }
    coordinates { [-53.587493896484375, -15.184914588928224] }
  end

  factory :collect_point2, class: 'CollectPoint' do
    name { 'Collect Point Area 3' }
    coordinates { [-57.581234896484375, -15.184123088928224] }
  end

  factory :collect_point3, class: 'CollectPoint' do
    name { 'Collect Point Area 4' }
    coordinates { [-53.487493896484375, -15.084914588928224] }
  end
end
