class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordNotUnique, with: :conflict
  rescue_from ActionController::ParameterMissing, with: :bad_request

private

  def not_found
    render json: { error: 'Not found' }, status: :not_found
  end

  # Fall back in case two records submitted at same time to get past validation
  def conflict
    render json: { error: 'Licence number already exists' }, status: :conflict
  end

  def bad_request(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end
