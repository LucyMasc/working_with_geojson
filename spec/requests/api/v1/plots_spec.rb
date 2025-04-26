require 'rails_helper'

RSpec.describe "Api::V1::Plots", type: :request do

  before :each do
    create :plot0
    # create :plot1
    create :plot2
  end

  describe "GET /index" do
    it 'returns a http status 200' do
      get '/api/v1/plots'
      expect(response).to have_http_status(:success)
    end

    it 'returns all plots' do
      get '/api/v1/plots'
      expect(JSON.parse(response.body)['features'].count).to eq(2)
    end

    it 'expects coordinates to be present in a plot' do
      get '/api/v1/plots'

      expect(JSON.parse(response.body)['features'].first['geometry']['coordinates']).to be_present
    end

    it 'returns the right coordinates that belongs to the right plot' do
      get '/api/v1/plots'

      expect(JSON.parse(response.body)['features'].first['properties']['name']).to eq('Factory Plot')
      expect(JSON.parse(response.body)['features'].first['geometry']['coordinates']).to match_array([[[-53.58890914916992, -15.185309410095217], [-53.588871002197266, -15.18528175354004], [-53.587493896484375, -15.184914588928224], [-53.58890914916992, -15.185309410095217]]])
    end
  end

  describe "POST /create" do
    it 'creates a new plot' do
      post '/api/v1/plots', params: {name: 'Testing Plot Creation', coordinates: {type: "Polygon", coordinates: [[[ 0 , 0 ],[ 3 , 6 ],[ 6 , 1 ],[ 0 , 0 ] ],[[ 2 , 2 ],[ 3 , 3 ],[ 4 , 2 ],[ 2 , 2 ]]]}}, as: :json

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['features'].first['properties']['name']).to eq('Testing Plot Creation')
      # could also match the array
    end

    it 'does not create a plot if no name is passed' do
      post '/api/v1/plots', params: {name: ' ', coordinates: {type: "Polygon", coordinates: [[[ 0 , 0 ],[ 3 , 6 ],[ 6 , 1 ],[ 0 , 0 ] ],[[ 2 , 2 ],[ 3 , 3 ],[ 4 , 2 ],[ 2 , 2 ]]]}}, as: :json

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['message']).to eq('Failed to save plot')
    end

    it 'does not create a plot with the same name of an existing plot' do
      post '/api/v1/plots', params: {name: 'Plot teste +1', coordinates: {type: "Polygon", coordinates: [[[ 0 , 0 ],[ 3 , 6 ],[ 6 , 1 ],[ 0 , 0 ] ],[[ 2 , 2 ],[ 3 , 3 ],[ 4 , 2 ],[ 2 , 2 ]]]}}, as: :json

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['message']).to eq('Failed to save plot')
    end

    it 'does not create a plot if empty coordinates is passed' do
      post '/api/v1/plots', params: {name: 'Plot teste Anot', coordinates: {coordinates:[]}}, as: :json

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['message']).to eq('Failed to save plot')
    end

    it 'does not create a plot if no parameter coordinates is passed' do
      post '/api/v1/plots', params: {name: 'Plot teste Anot'}, as: :json

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)['message']).to eq('Invalid Parameters')
    end
  end
end
