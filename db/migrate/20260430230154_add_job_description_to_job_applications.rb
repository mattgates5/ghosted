class AddJobDescriptionToJobApplications < ActiveRecord::Migration[8.1]
  def change
    add_column :job_applications, :job_description, :text
  end
end
