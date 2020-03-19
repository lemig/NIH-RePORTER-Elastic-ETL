class DiseasesController < ApplicationController
  before_action :set_disease, only: [:show, :edit]

  # GET /diseases
  # GET /diseases.json
  def index
    @diseases = Disease.all
  end

  # GET /diseases/1
  # GET /diseases/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_disease
      @disease = Disease.find(params[:id])
    end
end
