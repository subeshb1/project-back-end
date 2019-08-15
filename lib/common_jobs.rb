# frozen_string_literal: true

class CommonJobs
  attr_accessor :user, :user_collection, :user_jobs, :user_applied_jobs
  def initialize(user)
    @user = user
    @user_collection = fetch_user_comparisons
    @user_jobs = fetch_user_jobs(user.id)
    @user_applied_jobs = user.applied_jobs.pluck(:id)
  end

  def call; end

  def similar_user_scores
  end

  def fetch_user_comparisons
    jobs = Applicant.joins('right outer  join job_views on applicants.job_id = job_views.job_id AND applicants.user_id = job_views.user_id').select('job_views.job_id,job_views.user_id,applicants.id, job_views.status').where('job_views.job_id': user.job_views.pluck(:job_id))
    g = PivotTable::Grid.new do |g|
      g.source_data  = jobs
      g.column_name  = :job_id
      g.row_name     = :user_id
      g.value_name   = :applicant
      g.field_name   = :status
    end
    g.build
  end

  def filter_common_views(user2)
    user2_jobs = fetch_user_jobs(user2)
    (0..(user_jobs.size - 1)).each_with_object([[], []]) do |index, result|
      result[0] << (user_jobs[index] ? (user_jobs[index] + 2) : 1)
      result[1] << (user2_jobs[index] ? (user2_jobs[index] + 2) : 1)
      result
    end
  end

  def fetch_user_jobs(user)
    user_collection.rows.find { |x| x.header == user }&.data
  end

  def pearson_correlation_score(user2)
    user1_applied, user2_applied = filter_common_views(user2)

    return 0 if user1_applied.empty?

    user1_applied_sum = user1_applied.sum
    user2_applied_sum = user2_applied.sum
    sum_product_applied = (0..(user1_applied.size - 1)).inject(0) do |result, index|
      result += user1_applied[index] *
                user2_applied[index]
      result
    end
    user1_applied_length = user1_applied.length
    numerator = sum_product_applied -
                ((user1_applied_sum * user2_applied_sum).to_f /
                user1_applied_length)
    denominator = ((user1_applied_sum - user1_applied_sum**2.to_f /
                   user1_applied_length) *
                  (user2_applied_sum - user2_applied_sum**2.to_f /
                    user1_applied_length))**0.5

    denominator.zero? ? 0 : (numerator.to_f / denominator).round(4)
  end

  def fetch_user_excluded_jobs(other_user)
    User.find(other_user).viewed_jobs.joins(:job_views).select('jobs.id, job_views.status').where('application_deadline >= ? ', Date.today).where.not(id: user_applied_jobs).uniq
  end

  def user_based_recommendation(_count = 10)
    other_users = user_collection.row_headers - [user.id]
    total = {}
    users = {}
    similarity_score = {}
    other_users.each do |other_user|
      # other_user = object[:user]
      score = pearson_correlation_score(other_user)
      next unless score.positive?

      other_jobs = fetch_user_excluded_jobs(other_user)
      other_jobs.each do |job|
        total[job.id] ||= 0
        total[job.id] += (job.status + 1).to_f * score
        similarity_score[job.id] ||= 0
        similarity_score[job.id] += score
      end
    end

    result = total.each_with_object([]) do |(id, total), result|
      result << {
        id: id,
        score: (total.to_f / similarity_score[id]).round(4)
      }
    end
    result.sort_by { |x| x[:score] }.reverse
  end
end
