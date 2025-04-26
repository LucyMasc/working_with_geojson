class Api::V1::CollectPointsController < ApplicationController
  def index
    collect_points = CollectPoint.all

    geojson = {
      type: "FeatureCollection",
      features: collect_points.map do |cp|
        {
          type: "Feature",
          geometry: {
            type: "Point",
            coordinates: cp.coordinates
          },
          properties: {
            id: cp.id.to_s,
            name: cp.name,
            plots: cp.plot_ids
          }
        }
      end
    }

    render json: geojson
  end

  def show
    cp = CollectPoint.find_by(id: params[:id])
    return render json: { message: 'Collect Point not found' }, status: :not_found unless cp

    feature = {
      type: "Feature",
      geometry: {
        type: "Point",
        coordinates: cp.coordinates
      },
      properties: {
        id: cp.id.to_s,
        name: cp.name,
        plots: cp.plot_ids
      }
    }

    render json: feature
  end

  def create
    coords = params[:coordinates]
    return render json: { message: 'Coordinates are required' }, status: :bad_request unless coords

    plots = Plot.where(
      "coordinates": {
        "$geoIntersects" => {
          "$geometry" => {
            type: "Point",
            coordinates: coords
          }
        }
      }
    )

    collect_point = CollectPoint.create(
      name: params[:name],
      coordinates: coords,
      plot_ids: plots.map(&:id)
    )

    if collect_point.persisted?
      render json: {
        type: "Feature",
        geometry: {
          type: "Point",
          coordinates: collect_point.coordinates
        },
        properties: {
          id: collect_point.id.to_s,
          name: collect_point.name,
          plots: collect_point.plot_ids
        }
      }, status: :created
    else
      render json: { message: 'Failed to create Collect Point', errors: collect_point.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    collect_point = CollectPoint.find_by(id: params[:id])
    return render json: { message: 'Collect Point not found' }, status: :not_found unless collect_point

    coords = params[:coordinates]
    if coords.present?
      plots = Plot.where(
        "coordinates.coordinates": {
          "$geoIntersects" => {
            "$geometry" => {
              type: "Point",
              coordinates: coords
            }
          }
        }
      )

      collect_point.update(
        name: params[:name] || collect_point.name,
        coordinates: coords,
        plot_ids: plots.map(&:id)
      )
    end

    if collect_point.errors.empty?
      render json: {
        type: "Feature",
        geometry: {
          type: "Point",
          coordinates: collect_point.coordinates
        },
        properties: {
          id: collect_point.id.to_s,
          name: collect_point.name,
          plots: collect_point.plot_ids
        }
      }
    else
      render json: { message: 'Failed to update Collect Point', errors: collect_point.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    collect_point = CollectPoint.find_by(id: params[:id])
    return render json: { message: 'Collect Point not found' }, status: :not_found unless collect_point

    collect_point.destroy
    render json: { message: 'Collect Point successfully destroyed' }
  end
end
