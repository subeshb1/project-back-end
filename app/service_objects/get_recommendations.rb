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
    jobs = []
    recommendations = Recommendation.user_based_recommendation(user)
    recommendations.group_by { |x| x[:score] }.each_value do |value|
      jobs += Job.where(id: value.pluck(:id)).order(views: :desc)
    end
    jobs.first 15
  end

  def fetch_history
    []
  end

  def fetch_categories
    Job.select('distinct(jobs.*)')
       .where('application_deadline >= ? ', Date.today)
       .joins(:categories)
       .where.not(id: user.applications.pluck(:job_id))
       .where('categories.name': user.basic_information.categories.pluck(:name))
       .group(:id)
       .order(views: :desc)
       .limit(9)
  end

  def fetch_top_jobs
    Job.where('application_deadline >= ? ', Date.today)
       .where.not(id: user.applications.pluck(:job_id))
       .order(views: :desc).limit(9)
  end

  def fetch_latest_jobs
    Job.where('application_deadline >= ? ', Date.today)
       .where.not(id: user.applications.pluck(:job_id))
       .order(created_at: :desc, views: :asc)
       .limit(9)
  end
end
