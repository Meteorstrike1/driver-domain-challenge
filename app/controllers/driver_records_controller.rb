class DriverRecordsController < ApplicationController
  before_action :set_driver_record, only: %i[show update destroy]

  # GET /driver_records
  def index
    @driver_records = DriverRecord.all

    render json: @driver_records
  end

  # GET /driver_records/CASE0102TEXM
  def show
    render json: @driver_record
  end

  # POST /driver_records
  def create
    @driver_record = DriverRecord.new(driver_record_params)
    @driver_record.save_with_retry(params[:driver_record][:driving_licence_number].present?)
    render json: @driver_record, status: :created, location: @driver_record
  rescue ActiveRecord::RecordInvalid
    render json: @driver_record.errors, status: :unprocessable_content
  end

  # PATCH/PUT /driver_records/CASE0102TEXM
  def update
    permitted = params.require(:driver_record).permit(:first_names, :last_name, :driving_licence_type)

    if permitted.keys.empty?
      render json: { error: 'At least one of first_names, last_name, or driving_licence_type must be provided' },
             status: :unprocessable_content
    elsif @driver_record.update(permitted)
      render json: @driver_record
    else
      render json: @driver_record.errors, status: :unprocessable_content
    end
  end

  # DELETE /driver_records/CASE0102TEXM
  def destroy
    required_keys = %i[first_names last_name date_of_birth]
    required = params.expect(:first_names, :last_name, :date_of_birth)
    provided = required_keys.zip(required).to_h
    if @driver_record.record_match?(provided)
      @driver_record.destroy!
    else
      render json: { error: 'Does not match record' }, status: :conflict
    end
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def set_driver_record
    @driver_record = DriverRecord.find_by!(driving_licence_number: params[:driving_licence_number].upcase)
  end

  # Only allow a list of trusted parameters through.
  def driver_record_params
    params.expect(driver_record: %i[first_names last_name date_of_birth driving_licence_type])
          .merge(params[:driver_record]&.permit(:driving_licence_number))
  end
end
