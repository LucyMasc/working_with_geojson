require 'rails_helper'

RSpec.describe "Api::V1::CollectPoints", type: :request do

  before :each do
    # create :collect_point0
    create :collect_point1
    create :collect_point2
    create :collect_point3
    create :plot0
    create :plot1
    create :plot2
  end

  describe "GET /index" do
    it 'returns a http status 200' do
      get '/api/v1/collect_points'
      expect(response).to have_http_status(:success)
    end

    it 'returns all collect_points' do
      get '/api/v1/collect_points'
      expect(JSON.parse(response.body)['features'].count).to eq(4)
    end
  end

  describe "POST /create" do
    it 'creates a new collect point' do
      post '/api/v1/collect_points', params: {name: 'Testing Collect Point', coordinates: [4, 2]}, as: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['properties']['name']).to eq('Testing Collect Point')
    end

    it 'associates a collect point to an existing plot' do
      post '/api/v1/collect_points', params: {name: 'Testing Collect Point', coordinates: [4, 2]}, as: :json
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['properties']['name']).to eq('Testing Collect Point')
      expect(CollectPoint.where(id: JSON.parse(response.body)['properties']['id']).last.plots).not_to be_empty
    end
  end
end
