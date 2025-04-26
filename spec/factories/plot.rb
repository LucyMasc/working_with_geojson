FactoryBot.define do
  factory :plot do
    name { 'Default Plot' }

    factory :plot0 do
      name { 'Factory Plot' }
      coordinates { [build(:coordinate_plot_1)] }
    end

    factory :plot1 do
      name { 'Plot teste' }
      coordinates { [build(:coordinate_plot_2)] }
      collect_points { [create(:collect_point0)] }
    end

    factory :plot2 do
      name { 'Plot teste +1' }
      coordinates { [build(:coordinate_with_holes)] }
    end

    factory :plot3 do
      name { 'Plot teste +2' }
      coordinates { [] }
    end

    factory :plot4 do
      name { 'Plot teste +3' }
      coordinates { [] }
    end
  end
end
