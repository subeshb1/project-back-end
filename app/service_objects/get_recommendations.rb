# frozen_string_literal: true

class GetRecommendations
  attr_accessor :user
  def initialize(user)
    @user = user
  end

  def call
    {
      recommended: fetch_recommendations,
      history: fetch_history,
      categories: fetch_categories,
      top_jobs: fetch_top_jobs,
      latest_jobs: fetch_latest_jobs
    }
  end

  def fetch_recommendations
    Recommendation.user_based_recommendation(user).map { |x| Job.find(x[:id]) }
  end

  def fetch_history
    []
  end

  def fetch_categories
    Job.select('jobs.*').joins(:categories)
       .where('categories.name': user.basic_information.categories.pluck(:name))
       .order(views: :desc)
       .limit(9)
  end

  def fetch_top_jobs
    Job.order(views: :desc).limit(9)
  end

  def fetch_latest_jobs
    Job.where('created_at > ?', Date.today - 14.days).order(views: :desc).limit(9)
  end
end
