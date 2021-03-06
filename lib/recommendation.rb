# frozen_string_literal: true

class Recommendation
  def self.pearson_correlation_score(user1, user2)
    common_views = (user1.viewed_jobs.select(:id) &
                    user2.viewed_jobs.select(:id)).pluck(:id)

    user1_applied = user1.job_views.where(job_id: common_views).select('applicants.id, job_views.job_id')
                         .joins(%(LEFT JOIN "applicants" ON
                                "job_views"."user_id" = "applicants"."user_id"
                                AND
                                "job_views"."job_id" = "applicants"."job_id" ))
                         .map { |x| { applied: x.id ? 2 : 1, id: x.job_id } }
    user2_applied = user2.job_views.where(job_id: common_views).select('applicants.id, job_views.job_id')
                         .joins(%(LEFT JOIN "applicants" ON
                          "job_views"."user_id" = "applicants"."user_id"
                          AND
                          "job_views"."job_id" = "applicants"."job_id" ))
                         .map { |x| { applied: x.id ? 2 : 1, id: x.job_id } }
    return 0 if common_views.empty?

    user1_applied_sum = user1_applied.pluck(:applied).sum
    user2_applied_sum = user2_applied.pluck(:applied).sum
    sum_product_applied = common_views.inject(0) do |result, id|
      result += user1_applied.detect { |x| x[:id] == id }[:applied] *
                user2_applied.detect { |x| x[:id] == id }[:applied]
      result
    end
    common_views_length = common_views.length
    numerator = sum_product_applied -
                ((user1_applied_sum * user2_applied_sum).to_f /
                common_views_length)
    denominator = ((user1_applied_sum - user1_applied_sum**2.to_f /
                   common_views_length) *
                  (user2_applied_sum - user2_applied_sum**2.to_f /
                    common_views_length))**0.5

    denominator.zero? ? 0 : (numerator.to_f / denominator).round(4)
  end

  def self.get_job_point(user, job_id)
    user.applied_jobs.where(id: job_id).size + 1
  end

  def self.get_most_similar_users(user)
    users = []
    User.job_seeker.where.not(id: user.id).each do |other_user|
      score = pearson_correlation_score(user, other_user)
      next unless score.positive?

      users << {
        user: other_user,
        score: score
      }
    end
    users.sort_by { |x| x[:score] }.reverse
  end

  def self.user_based_recommendation(user, _count = 10)
    other_users = get_most_similar_users(user)
    total = {}
    users={}
    similarity_score = {}
    other_users.each do |object|
      other_user = object[:user]
      score = object[:score]
      next unless score.positive?

      other_jobs = other_user.viewed_jobs.where('application_deadline >= ? ', Date.today) - user.applied_jobs
      other_jobs.each do |job|
        total[job.id] ||= 0
        total[job.id] += get_job_point(other_user, job.id).to_f * score
        users[job.id] ||= []
        users[job.id] << {user: other_user, score: score}
        similarity_score[job.id] ||= 0
        similarity_score[job.id] += score
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

  def self.item_based_recommendation(user, job)
    applied_users = User.where(id: Applicant.where(job_id: job.id).pluck(:user_id)).where.not(id:user.id)
    jobs = {}
    applied_users.each do |other_user|
      other_jobs = other_user.applied_jobs.where('application_deadline >= ? ', Date.today) - user.applied_jobs - [job]
      other_jobs.each do |job|
        jobs[job.id] ||= 0
        jobs[job.id]  += 0
      end
    end
    result = jobs.each_with_object([]) do |(id, total), result|
      result << {
        id: id,
        score: total
      }
    end
    result.sort_by { |x| x[:score] }.reverse
  end
end
