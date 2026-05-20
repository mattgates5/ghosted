class AddArchivedToJobApplications < ActiveRecord::Migration[8.1]
  def change
    add_column :job_applications, :archived, :boolean, default: false, null: false
  end
end
