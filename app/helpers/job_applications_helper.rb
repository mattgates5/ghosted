module JobApplicationsHelper
  def sortable_header(label, column, current_sort, current_dir, params)
    if current_sort == column
      new_dir = current_dir == "asc" ? "desc" : "asc"
      indicator = current_dir == "asc" ? " ▲" : " ▼"
    else
      new_dir = "asc"
      indicator = ""
    end

    url = job_applications_path(params.permit(:q, :status, :location, :location_type).merge(sort: column, dir: new_dir))
    content_tag(:th, class: "sortable #{"sorted" if current_sort == column}") do
      link_to "#{label}#{indicator}".html_safe, url
    end
  end
end
