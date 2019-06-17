# frozen_string_literal: true

module Recommendation
#   def pearson_correlation_score(user1, user2)
#     common_views = (user1.viewed_jobs & user2.viewed_jobs).map(&:id)

#     return 0 if common_views.empty?

#     user1_applied_sum =get_applied_count user1, common_views
#       user2_applied_sum = get_applied_count user2, common_views
#     sum_product_applied = common_views.inject(0) do |result, data|
#       result += get_applied_count(user1, data) * get_applied_count(user2, data)
#       result
#     end
#     common_views_length = common_views.length
#     numerator = sum_product_applied - ((user1_applied_sum * user2_applied_sum).to_f / common_views_length)
#     denominator = ((user1_applied_sum - user1_applied_sum**2.to_f  / common_views_length) *
#                   (user2_applied_sum - user2_applied_sum**2.to_f / common_views_length))**0.5

#     # Handling 'Divide by Zero' error.
#     denominator.zero? ? 0 : numerator.to_f / denominator
#   end

#   def get_applied_count(user, jobs)
#     user.applied_jobs.where(id: jobs).size
#   end

#   def recommend_movies # recommend movies to a user
#     # find all other users, equivalent to .where(‘id != ?’, self.id)
#     other_users = self.class.all.where.not(id: id)
#     # instantiate a new hash, set default value for any keys to 0
#     recommended = Hash.new(0)
#     # for each user of all other users
#     other_users.each do |user|
#       # find the movies this user and another user both liked
#       common_movies = user.movies & movies
#       # calculate the weight (recommendation rating)
#       weight = common_movies.size.to_f / user.movies.size
#       # add the extra movies the other user liked
#       (user.movies — common_movies).each do |movie|
#         # put the movie along with the cumulative weight into hash
#         recommended[movie] += weight
#       end
#     end
#     # sort by weight in descending order
#     sorted_recommended = recommended.sort_by { |_key, value| value }.reverse
#   end
# end
# user1_data = user1.viewed_jobs.select('applicants.id, jobs_views.job_id') .joins('RIGHT JOIN "applicants" ON "jobs_views"."user_id" = "applicants"."user_id" AND "jobs_views"."job_id" = "applicants"."job_id" ') .map { |x| { applicant_id: x.id, job_id: x.job_id } }
# jobs = Job.last(9)

# user1 = User.last
# user2 = User.first

# %w[
#   1
#   0
#   0
#   0
#   1
#   1
#   0
#   0
#   0
# ].each_with_index do |val, index|
#   user1.viewed_jobs << jobs[index]
#   user1.applied_jobs << jobs[index] if val == '1'
# end

# %w[
#   1
#   0
#   0
#   0
#   1
#   1
#   0
#   0
#   1
# ].each_with_index do |val, index|
#   user2.viewed_jobs << jobs[index]
#   user2.applied_jobs << jobs[index] if val == '1'
end
