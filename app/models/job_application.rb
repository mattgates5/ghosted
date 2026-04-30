class JobApplication < ApplicationRecord
  LOCATIONS = ["Remote", "SF Bay Area", "San Francisco", "Sacramento", "Other"].freeze
  LOCATION_TYPES = ["Remote", "Hybrid", "On-site"].freeze
  STATUSES = ["Interested", "Applied", "Phone Screen", "Interview", "Offer", "Rejected", "Ghosted", "Withdrawn"].freeze

  CSV_HEADERS = %w[Company Title Status URL Applied Closed Location Type Notes Tags].freeze

  def self.to_csv(records)
    require "csv"
    CSV.generate(headers: true) do |csv|
      csv << CSV_HEADERS
      records.each do |app|
        csv << [
          app.company, app.title, app.status, app.url,
          app.applied_on, app.closed_on,
          app.location, app.location_type,
          app.notes, app.tags
        ]
      end
    end
  end

  validates :company, presence: true
  validates :title, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :location_type, inclusion: { in: LOCATION_TYPES }, allow_blank: true

  before_validation :set_defaults

  def tag_list
    tags.to_s.split(",").map(&:strip).reject(&:empty?)
  end

  def tag_list=(value)
    self.tags = value.is_a?(Array) ? value.join(", ") : value
  end

  private

  def set_defaults
    self.status ||= "Applied"
    self.applied_on ||= Date.today unless status == "Interested"
  end
end
