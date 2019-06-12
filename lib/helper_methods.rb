# frozen_string_literal: true

file = File.read('data/education.json')
education_hash = JSON.parse(file)

def create_a_user(params = {})
  require 'faker'
  user_params = {
    email: Faker::Internet.email,
    password: '12345678',
    password_confirmation: '12345678',
    role: 0
  }
  User.create!(user_params.merge!(params))
end

def get_auth(user)
  JsonWebToken.encode(user_id: user.uid)
end

def create_job_seeker_profile(user, educations, work_experiences)
  user ||= create_a_user
  UpdateBasicInformation.new({
                               name: Faker::Name.name,
                               description: Faker::Lorem.paragraph_by_chars(256, false),
                               birth_date: Faker::Date.birthday(18, 65).to_datetime.to_time.iso8601,
                               gender: %w[male female other].sample,
                               website: Faker::Internet.url,
                               phone_numbers: {
                                 home: Faker::PhoneNumber.phone_number_with_country_code

                               },
                               address: {
                                 permantent: %w[kathmandu lalitpur bhaktapur butwal morang dhading shurkhet dharan].sample.capitalize
                               }

                             }, user).call
  UpdateEducation.new(user,  educations).call
  UpdateWorkExperience.new(user,  work_experiences).call
end



def extract_education_work_experience
  file = File.read('data/education.json')
  education_hash = JSON.parse(file)
  file = File.read('data/jobs.json')
  job_hash = JSON.parse(file)
  education_work_experience = []
  education_hash.each do |degree, values|
    values.each do |category|
      category.each do |category_name, values|
        values.each do |value|
          start_date = rand(3..7).years.ago
          work_year = start_date + rand(-2..2).year
          education_work_experience << {
            educations: [{ degree: degree,
                           categories: [category_name],
                           program: value['course'],
                           start_date: start_date.to_time.iso8601,
                           end_date: (start_date + value['time'].year).to_time.iso8601 }],
            work_experiences: rand(1..2) == 1 && !job_hash[category_name].nil? ? [
              {
                job_title: job_hash[category_name].sample,
                organization_name: Faker::Company.name,
                level: %w[entry_level mid_level senior_level top_level].sample,
                start_date: work_year.to_time.iso8601,
                end_date: (work_year + rand(1..6).year).to_time.iso8601,
                categories: [category_name],
                salary: rand(1..10) * 10_000,
                description: Faker::Lorem.paragraph_by_chars(256, false)

              }
            ] : []
          }
        end
      end
    end
  end
  education_work_experience
end


def create_fake_job_seeker
  extract_education_work_experience.each do |value|
    create_job_seeker_profile(nil, {educations: value[:educations]},{work_experiences: value[:work_experiences]})
  end
end


def create_fake_job_provider

end


def extract_jobs
  file = File.read('data/jobs.json')
  job_hash = JSON.parse(file)
  jobs = {}
  job_hash.each do |key, values|
    jobs[key] = []
    values.each do
      
    end
  end
end