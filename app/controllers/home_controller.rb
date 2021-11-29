class HomeController < ApplicationController
  include HomeHelper

  def index
    @clubs_count        = Club.count
    @runners_count      = Runner.count
    @competitions_count = Competition.count
    @results_count      = Result.count
  end

  def add_competition_file
    return unless params[:path]

    path = params[:path].tempfile.path
    parse_data(path)
  end
end
