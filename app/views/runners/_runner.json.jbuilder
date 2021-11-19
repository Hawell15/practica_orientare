json.extract! runner, :id, :runner_name, :surname, :dob, :category, :club, :gender, :created_at, :updated_at
json.url runner_url(runner, format: :json)
