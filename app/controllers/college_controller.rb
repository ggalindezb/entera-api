class CollegeController < ApplicationController
  def index
    results = CollegeApi.search(school_name: index_params[:school_name])

    render json: results
  end

  private

  def index_params
    params.permit(:school_name)
  end
end
