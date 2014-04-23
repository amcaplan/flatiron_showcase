class StaticPagesController < ApplicationController
  def index
    @projects = Project.where.not(brief_description: nil).last(7).shuffle.first(3)
    # TODO Remove before launching for good
    if @projects.length < 3
      @projects = [@projects[0], @projects[0], @projects[0]]
    end
  end

  def showcase
    @projects = Project.where.not(brief_description: nil,
      longer_description: nil).all.shuffle
    @colors = (0..3).to_a.shuffle.cycle
    render layout: false
  end

  def about
    @dev_team = User.where(:github_login => ["amcaplan", "bokwon"]).all
    @page_name = "Meet the Flatiron Showcase Developers"
  end
end
