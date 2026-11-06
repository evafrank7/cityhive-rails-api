class ApplicationController < ActionController::API
  rescue_from Mongoid::Errors::DocumentNotFound, with: :record_not_found
  rescue_from ActionController::BadRequest, with: :bad_request

  private

  def record_not_found(_exception)
    render json: { error: "Resource not found" }, status: :not_found
  end

  def bad_request(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end
