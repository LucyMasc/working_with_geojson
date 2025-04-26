class Api::V1::PlotsController < ApplicationController
  def index
    plots = Plot.all

    geojson = {
      type: "FeatureCollection",
      features: plots.map do |plot|
        {
          type: "Feature",
          geometry: {
            type: plot.coordinates.first[:type],
            coordinates: plot.coordinates.first[:coordinates]
          },
          properties: {
            id: plot.id.to_s,
            name: plot.name,
            collect_points: plot.collect_point_ids
          }
        }
      end
    }

    render json: geojson
  end

  def show
    plot = Plot.where(id: params[:id]).last

    if plot.nil?
      render json: { message: 'Plot not found' }, status: 404
    else
      geometry = plot.coordinates.first

      geojson = {
        type: "FeatureCollection",
        features: [
          {
            type: "Feature",
            geometry: {
              type: geometry[:type],
              coordinates: geometry[:coordinates]
            },
            properties: {
              id: plot.id.to_s,
              name: plot.name,
              collect_points: plot.collect_point_ids
            }
          }
        ]
      }

      render json: geojson
    end
  end

  def create
    unless params[:coordinates]&.dig(:coordinates)
      return render json: { message: 'Invalid Parameters' }, status: 400
    end

    geometry = {
      type: "Polygon",
      coordinates: params[:coordinates][:coordinates]
    }

    plot = Plot.create(
      name: params[:name],
      coordinates: [geometry]
    )

    if plot.persisted?
      geojson = {
        type: "FeatureCollection",
        features: [
          {
            type: "Feature",
            geometry: geometry,
            properties: {
              id: plot.id.to_s,
              name: plot.name,
              collect_points: plot.collect_point_ids
            }
          }
        ]
      }

      render json: geojson
    else
      render json: { message: 'Failed to save plot', errors: plot.errors.full_messages }, status: 400
    end
  end
end
