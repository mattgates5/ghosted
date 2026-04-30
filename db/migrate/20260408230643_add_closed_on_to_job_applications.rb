class AddClosedOnToJobApplications < ActiveRecord::Migration[8.1]
  def change
    add_column :job_applications, :closed_on, :date
  end
end
