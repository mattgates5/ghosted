class CreateJobApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :job_applications do |t|
      t.string :company
      t.string :title
      t.date :applied_on
      t.string :location
      t.string :location_type
      t.string :status
      t.string :url
      t.text :notes
      t.string :tags

      t.timestamps
    end
  end
end
