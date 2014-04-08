json.array!(@projects) do |project|
  json.extract! project, :id, :name, :live_app_url, :screenshot_path, :brief_description, :longer_description
  json.url project_url(project, format: :json)
end
