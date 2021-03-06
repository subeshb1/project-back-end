# # frozen_string_literal: true

# def test
#   # Jobs in each category A job can have multiple category
#   Job.joins('LEFT OUTER JOIN "categories_jobs" ON "categories_jobs"."job_id" = "jobs"."id" LEFT OUTER  JOIN "categories" ON "categories"."id" = "categories_jobs"."category_id"').group('categories.name').count

#   # Applicant in each category
#   Job.joins('LEFT OUTER JOIN "categories_jobs" ON "categories_jobs"."job_id" = "jobs"."id" LEFT OUTER  JOIN "categories" ON "categories"."id" = "categories_jobs"."category_id"').joins(:applicants).group('categories.name').count
#   Job.joins('LEFT OUTER JOIN "categories_jobs" ON "categories_jobs"."job_id" = "jobs"."id" LEFT OUTER  JOIN "categories" ON "categories"."id" = "categories_jobs"."category_id"').joins(:job_views).group('categories.name').count
#   sales = Applicant.joins('right outer  join job_views on applicants.job_id = job_views.job_id AND applicants.user_id = job_views.user_id').select('job_views.job_id,job_views.user_id,applicants.id, job_views.status').where('job_views.job_id': User.job_seeker.first.job_views.pluck(:job_id))
#   g = PivotTable::Grid.new do |g|
#     g.source_data  = sales
#     g.column_name  = :job_id
#     g.row_name     = :user_id
#     g.value_name   = :applicant
#     g.field_name   = :status
#   end

#   CSV.open('test_data.csv', 'w') do |csv|
#     csv << (['User/Job'] | g.column_headers)
#     g.rows.each do |row|
#       csv << ([row.header].concat row.data)
#     end
#   end
#   Applicant.all.each do |applicant|
#     JobView.where(job_id: applicant.job_id, user_id: applicant.user_id).update_all(status: 1)
#   end
# end

# def test_2
#   Job.count
#   User.job_seeker.count
#   User.job_provider.count
#   User.job_provider.count
#   JobView.count
#   Applicant.count
# end

# def view_or_apply(user, category)
#   jobs = GetJobList.new(categories: category).call
#   jobs.sample(10).each do |job|
#     user.viewed_jobs << job
#     user.applied_jobs << job  && if rand(0..4) == 1
#   end
# end

# # def test_data
# #   categories = [
# #     'Science and Technology',
# #     'Pharmacy',
# #     'Nursing',
# #     'Management',
# #     'Medicine and Health Care',
# #     'Law, public safety and security',
# #     'Engineering',
# #     'Computer and IT',
# #     'Education',
# #     'Ayurved',
# #     'Agriculture'
# #   ].sort

# #   users = []
# #   categories.each do |category|
# #     user = create_a_user
# #     users << user
# #     view_or_apply(user, [category])
# #   end
# #   random_users = (1..8).map { create_a_user }
# #   random_users.each do |user|
# #     view_or_apply(user, categories)
# #   end
# # end

# # def make_result(id)
# #   RecommendationV2.new(User.find(id)).similar_user_scores
# # end

