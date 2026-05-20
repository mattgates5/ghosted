module Api
  module V1
    class JobApplicationsController < BaseController
      before_action :set_job_application, only: %i[show update destroy job_description]

      def index
        render json: JobApplication.with_filters(params)
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

      def job_description
        render json: {
          id: @job_application.id,
          job_description: @job_application.job_description
        }
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
          :location, :location_type, :status, :url, :notes, :tags, :job_description
        )
      end
    end
  end
end
