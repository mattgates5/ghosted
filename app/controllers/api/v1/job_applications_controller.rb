module Api
  module V1
    class JobApplicationsController < BaseController
      before_action :set_job_application, only: %i[show update destroy]

      def index
        apps = JobApplication.all
        apps = apps.where(status: params[:status]) if params[:status].present?
        apps = apps.where(location: params[:location]) if params[:location].present?
        apps = apps.where(location_type: params[:location_type]) if params[:location_type].present?
        if params[:q].present?
          q = "%#{params[:q]}%"
          apps = apps.where("company LIKE ? OR title LIKE ? OR notes LIKE ? OR tags LIKE ?", q, q, q, q)
        end
        render json: apps
      end

      def show
        render json: @job_application
      end

      def create
        app = JobApplication.new(job_application_params)
        if app.save
          render json: app, status: :created
        else
          render_error(app.errors.full_messages, :unprocessable_entity)
        end
      end

      def update
        if @job_application.update(job_application_params)
          render json: @job_application
        else
          render_error(@job_application.errors.full_messages, :unprocessable_entity)
        end
      end

      def destroy
        @job_application.destroy
        head :no_content
      end

      private

      def set_job_application
        @job_application = JobApplication.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render_error("Not found", :not_found)
      end

      def job_application_params
        params.require(:job_application).permit(
          :company, :title, :applied_on, :closed_on,
          :location, :location_type, :status, :url, :notes, :tags
        )
      end
    end
  end
end
