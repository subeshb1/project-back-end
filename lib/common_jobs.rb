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

  def similar_user_scores; end

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
      if user_jobs[index] && user2_jobs[index]
        result[0] << user_jobs[index] + 1
        result[1] << user2_jobs[index] + 1
      end
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
        # users[job.id] ||= []
        # users[job.id] << {user: other_user, score: score}
        # similarity_score[job.id] ||= 0
        # similarity_score[job.id] += score
      end
    end

    result = total.each_with_object([]) do |(id, total), result|
      result << {
        id: id,
        # user: users[id],
        score: (total.to_f).round(4)
      }
    end
    result.sort_by { |x| x[:score] }.reverse
  end
end
[{:id=>721, :score=>0.6666},
  {:id=>665, :score=>0.6666},
  {:id=>657, :score=>0.6666},
  {:id=>702, :score=>0.6666},
  {:id=>663, :score=>0.6666},
  {:id=>720, :score=>0.6666},
  {:id=>694, :score=>0.6666},
  {:id=>658, :score=>0.5333},
  {:id=>676, :score=>0.5333},
  {:id=>683, :score=>0.5333},
  {:id=>681, :score=>0.4593},
  {:id=>661, :score=>0.4},
  {:id=>672, :score=>0.4},
  {:id=>692, :score=>0.3333},
  {:id=>651, :score=>0.3333},
  {:id=>684, :score=>0.3333},
  {:id=>675, :score=>0.3333},
  {:id=>682, :score=>0.3333},
  {:id=>697, :score=>0.3333},
  {:id=>700, :score=>0.3333},
  {:id=>727, :score=>0.3333},
  {:id=>667, :score=>0.3333},
  {:id=>725, :score=>0.3333},
  {:id=>164, :score=>0.252},
  {:id=>172, :score=>0.252},
  {:id=>132, :score=>0.252},
  {:id=>262, :score=>0.252},
  {:id=>1596, :score=>0.252},
  {:id=>71, :score=>0.252},
  {:id=>63, :score=>0.252},
  {:id=>61, :score=>0.252},
  {:id=>673, :score=>0.2},
  {:id=>674, :score=>0.2},
  {:id=>724, :score=>0.2},
  {:id=>688, :score=>0.2},
  {:id=>678, :score=>0.2},
  {:id=>722, :score=>0.2},
  {:id=>669, :score=>0.2},
  {:id=>4, :score=>0.126},
  {:id=>257, :score=>0.126},
  {:id=>7, :score=>0.126},
  {:id=>203, :score=>0.126},
  {:id=>209, :score=>0.126},
  {:id=>240, :score=>0.126},
  {:id=>659, :score=>0.126},
  {:id=>241, :score=>0.126},
  {:id=>193, :score=>0.126},
  {:id=>53, :score=>0.126},
  {:id=>202, :score=>0.126},
  {:id=>159, :score=>0.126}]
 