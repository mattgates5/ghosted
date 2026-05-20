class JobApplicationsController < ApplicationController
  before_action :set_job_application, only: %i[show edit update destroy]

  SORT_COLUMNS = %w[company title applied_on closed_on location location_type status].freeze
  INACTIVE_STATUSES = %w[Rejected Ghosted Withdrawn].freeze

  def index
    @current_view = :all
    @job_applications = build_scope(JobApplication.all)
    respond_with_formats(JobApplication.all)
  end

  def active
    @current_view = :active
    base = JobApplication.where(archived: false).where.not(status: INACTIVE_STATUSES)
    @job_applications = build_scope(base)
    respond_with_formats(base)
  end

  def archived
    @current_view = :archived
    base = JobApplication.where(archived: true)
    @job_applications = build_scope(base)
    respond_with_formats(base)
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

  def build_scope(base)
    scope = base.with_filters(params)

    sort_col = SORT_COLUMNS.include?(params[:sort]) ? params[:sort] : "applied_on"
    sort_dir = params[:dir] == "asc" ? "asc" : "desc"
    @sort = sort_col
    @dir = sort_dir

    scope.order("#{sort_col} #{sort_dir}")
  end

  def respond_with_formats(chart_base)
    respond_to do |format|
      format.html do
        counts = chart_base.group(:status).count
        @by_status = JobApplication::STATUSES.filter_map { |s| [s, counts[s]] if counts[s] }
        @by_day = chart_base.where.not(status: "Interested").group_by_day(:applied_on).count
        render :index
      end
      format.csv do
        send_data JobApplication.to_csv(@job_applications), filename: "job_applications_#{Date.today}.csv"
      end
    end
  end

  def job_application_params
    params.require(:job_application).permit(
      :company, :title, :applied_on, :location, :location_type,
      :status, :url, :notes, :tags, :closed_on, :job_description, :archived
    )
  end
end
