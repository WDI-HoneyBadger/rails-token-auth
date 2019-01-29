class ApplicationController < ActionController::API
  
  def require_token
    token = params.require(:auth_token)
    @current_user = User.find_by( auth_token: token )

    unless @current_user 
      render json: { errors: "invalid token" }, status: :unauthorized
    end
  end

  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
    render json: { errors: parameter_missing_exception }, status: :unprocessable_entity
  end

  rescue_from(ActiveRecord::RecordNotFound) do |missing_record_exception|
    render json: { errors: missing_record_exception }, status: :not_found
  end

  rescue_from(ActiveRecord::RecordInvalid) do |invalid_record_exception|
    render json: { errors: invalid_record_exception.record.errors.messages }, status: :bad_request
  end
end
