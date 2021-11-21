module ApplicationHelper
  def default_category
    Category.find(10)
  end

  def default_competition
    Competition.find(0)
  end

  def default_club
    Club.find(0)
  end

  def default_group
    Group.find(0)
  end

  def add_group(hash)
    return default_group if hash[:group_name].blank?

    group = Group.find_by(hash.slice(:competition_id, :group_name))
    return group if group

    group_hash = hash.slice(:competition_id, :group_name, :clasa, :rang).compact

    Group.create(group_hash)
  end

  def add_competition(hash)
    return default_competition if hash[:competition_name].blank?

    hash[:date] = (hash[:date] || "#{hash["date(1i)"]}-#{hash["date(2i)"]}-#{hash["date(3i)"]}").to_date.as_json

    competition = Competition.find_by(hash.slice(:competition_name, :date, :distance_type))
    return competition if competition

    competition_hash = hash.slice(:competition_name, :date, :location, :country, :distance_type).compact

    new_competition = Competition.create(competition_hash)
    add_group({ group_name: "New", competition_id: new_competition })
    new_competition
  end

  def add_club(hash)
    return default_club if hash[:club_name].blank?

    club = Club.find_by(hash.slice(:club_name))
    return club if club

    club_hash = hash.slice(:club_name, :territory, :representative, :email, :phone).compact
    Club.create(club_hash)
  end

  def add_runner(hash, category_id = nil)
    runner_id = Runner.find_by(hash.slice(:runner_name, :surname))

    return runner_id if runner_id

    runner_hash = hash.slice(:runner_name, :surname, :dob, :club_id, :gender).compact
    new_runner = Runner.create(runner_hash)

    if category_id && category_id != default_category.id
      result_hash = { runner_id: new_runner.id, group_id: default_group.id, category_id: category_id }
      add_result(result_hash)
    end

    new_runner
  end

  def add_result(hash)
    result_id = Result.find_by(hash.slice(:runner_id, :group_id))
    return result_id if result_id

    result_hash = hash.slice(:runner_id, :group_id, :category_id, :place, :time).compact

    Result.create(result_hash)
  end

  def competition_id(params)
    return default_competition if params[:competition_id] == default_competition.id
    return params[:competition_id] unless Competition.find(params[:competition_id].to_i).competition_name == 'New'

    add_competition(params).id
  end

  def group_id(params)
    return default_group if params[:group_id] == default_group.id
    return params[:group_id] unless Group.find(params[:group_id]).group_name == "New"

    add_group(params).id
  end

  def get_category(runner, date = Time.now)
    return default_category if runner.results.blank?

    runner.results.select { |result| ((date - 2.years)..date).cover?(result.group.competition.date) }
      .map(&:category).uniq.sort_by(&:id).min rescue default_category
  end
end
