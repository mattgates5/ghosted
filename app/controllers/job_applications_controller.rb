class JobApplicationsController < ApplicationController
  before_action :set_job_application, only: %i[show edit update destroy]

  SORT_COLUMNS = %w[company title applied_on closed_on location location_type status].freeze

  def index
    @job_applications = JobApplication.all

    if params[:status].present?
      @job_applications = @job_applications.where(status: params[:status])
    end

    if params[:location].present?
      @job_applications = @job_applications.where(location: params[:location])
    end

    if params[:location_type].present?
      @job_applications = @job_applications.where(location_type: params[:location_type])
    end

    if params[:q].present?
      q = "%#{params[:q]}%"
      @job_applications = @job_applications.where(
        "company LIKE ? OR title LIKE ? OR notes LIKE ? OR tags LIKE ?", q, q, q, q
      )
    end

    sort_col = SORT_COLUMNS.include?(params[:sort]) ? params[:sort] : "applied_on"
    sort_dir = params[:dir] == "asc" ? "asc" : "desc"
    @job_applications = @job_applications.order("#{sort_col} #{sort_dir}")

    @sort = sort_col
    @dir = sort_dir

    respond_to do |format|
      format.html do
        counts = JobApplication.group(:status).count
        @by_status = JobApplication::STATUSES.filter_map { |s| [s, counts[s]] if counts[s] }
        @by_day = JobApplication.where.not(status: "Interested").group_by_day(:applied_on).count
      end
      format.csv do
        send_data JobApplication.to_csv(@job_applications), filename: "job_applications_#{Date.today}.csv"
      end
    end
  end

  def show
  end

  def new
    @job_application = JobApplication.new(applied_on: Date.today)
  end

  def create
    @job_application = JobApplication.new(job_application_params)
    @job_application.applied_on = nil if params[:clear_applied_on] == "1"
    if @job_application.save
      redirect_to job_applications_path, notice: "Application added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    attrs = job_application_params
    attrs = attrs.merge(applied_on: nil) if params[:clear_applied_on] == "1"
    if @job_application.update(attrs)
      redirect_to job_applications_path, notice: "Application updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @job_application.destroy
    redirect_to job_applications_path, notice: "Application deleted."
  end

  private

  def set_job_application
    @job_application = JobApplication.find(params[:id])
  end

  def job_application_params
    params.require(:job_application).permit(
      :company, :title, :applied_on, :location, :location_type,
      :status, :url, :notes, :tags, :closed_on
    )
  end
end
