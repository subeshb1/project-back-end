# frozen_string_literal: true

def create_a_user(params = {})
  require 'faker'
  user_params = {
    email: Faker::Internet.unique.email,
    password: '12345678',
    password_confirmation: '12345678',
    role: 0
  }
  User.create!(user_params.merge!(params))
end

def get_auth(user)
  JsonWebToken.encode(user_id: user.uid)
end

def view_or_apply(user)
  return if user.basic_information.categories.pluck(:name).empty?

  jobs = GetJobList.new(categories: user.basic_information.categories.pluck(:name)).call
  jobs.sample(rand(4..20)).each do |job|
    user.viewed_jobs << job
    user.applied_jobs << job if rand(0..2) == 1
  end
end

def create_job_seeker_profile(user, basic_information, educations, work_experiences)
  user ||= create_a_user
  UpdateBasicInformation.new(basic_information, user).call
  UpdateEducation.new(user,  educations).call
  UpdateWorkExperience.new(user, work_experiences).call
  view_or_apply(user)
  user
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
            basic_information: {
              name: Faker::Name.unique.name,
              description: Faker::Lorem.paragraph_by_chars(256, false),
              birth_date: Faker::Date.birthday(18, 65).to_datetime.to_time.iso8601,
              gender: %w[male female other].sample,
              website: Faker::Internet.unique.url,
              phone_numbers: {
                home: Faker::PhoneNumber.phone_number_with_country_code,
                personal: Faker::PhoneNumber.phone_number_with_country_code
              },
              address: {
                permanent: %w[kathmandu lalitpur bhaktapur butwal morang dhading shurkhet dharan].sample.capitalize
              },
              categories: [category_name]
            },
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

def create_fake_job_seekers
  extract_education_work_experience.each do |value|
    create_job_seeker_profile(nil, value[:basic_information], { educations: value[:educations] }, work_experiences: value[:work_experiences])
  end
end

def create_job_provider_jobs(user, basic_information, jobs)
  user ||= create_a_user role: 1
  UpdateBasicInformation.new(basic_information, user).call
  jobs.each do |job|
    user.jobs << CreateJob.new(user, job).call
  end
  user
end

def create_fake_job_providers
  extract_company_jobs.each do |value|
    create_job_provider_jobs(nil, value[:basic_information], value[:jobs])
  end
end

def extract_company_jobs
  company_info = []
  file = File.read('data/jobs.json')
  job_hash = JSON.parse(file)
  Category.all.map(&:name).each do |category_name|
    rand(10..15).times.each do
      name = Faker::Company.unique.name
      basic_information = {
        name: name,
        address: { permanent: %w[kathmandu lalitpur bhaktapur butwal morang dhading shurkhet dharan].sample.capitalize },
        description: Faker::Lorem.paragraph_by_chars(256, false),
        established_date: Faker::Date.birthday(18, 65).to_datetime.to_time.iso8601,
        organization_type: BasicInformation::ORGANIZATION_TYPE.values.sample,
        website: Faker::Internet.unique.url,
        phone_numbers: {
          home: Faker::PhoneNumber.phone_number_with_country_code,
          personal: Faker::PhoneNumber.phone_number_with_country_code
        },
        categories: [category_name]
      }

      jobs = []

      job_hash[category_name].sample(rand(4..30)).each do |job_title|
        level =  %w[entry_level mid_level senior_level top_level].sample
        salary = {
          "entry_level": 10_000,
          "mid_level": 30_000,
          "senior_level": 50_000,
          "top_level": 70_000
        }.with_indifferent_access
        min_salary = salary[level]
        degree = {
          "entry_level": ['Bachelor', 'Intermediate', 'SLC/SEE', 'Other'],
          "mid_level": ['Master', 'Bachelor', 'Intermediate', 'SLC/SEE', 'Other'],
          "senior_level": ['Master', 'Bachelor', 'Other', 'Ph. D.'],
          "top_level": ['Master', 'Bachelor', 'Other', 'Ph. D.']
        }.with_indifferent_access
        job_type = {
          "entry_level": %w[internship part_time full_time],
          "mid_level": %w[part_time full_time contract],
          "senior_level": %w[full_time contract],
          "top_level": %w[full_time contract]
        }.with_indifferent_access
        jobs << {
          job_title: job_title,
          categories: [category_name],
          open_seats: rand(1..5),
          level: level,
          min_salary: min_salary,
          max_salary: min_salary + rand(0..3) * 10_000,
          job_type: job_type[level].sample,
          application_deadline: (Date.today + rand(1..150).days).to_datetime.to_time.iso8601,
          description: Faker::Lorem.paragraph_by_chars(256, false),
          job_specifications: {
            degree: {
              value: [degree[level].sample],
              require: false
            },
            program: {
              value: [],
              require: false
            },
            experience: {
              value: [rand(1..5).to_s],
              require: false
            },
            gender: {
              value: [BasicInformation::GENDER.values.sample],
              require: false
            },
            age: {
              min: 16,
              max: 69,
              require: false
            }
          }

        }
      end
      company_info << {
        basic_information: basic_information,
        jobs: jobs
      }
    end
  end
  company_info
end

def create_exams
  exams = [
    {
      name: 'Agriculture',
      file: 'data/test_agriculture.json'
    },
    {
      name: 'Ayurved',
      file: 'data/test_ayurved.json'
    },
    {
      name: 'Education',
      file: 'data/test_education.json'
    },
    {
      name: 'engineering',
      file: 'data/test_engineering.json'
    },
    {
      name: 'healthcare',
      file: 'data/test_healthcare.json'
    },
    {
      name: 'java',
      file: 'data/test_java.json'
    },
    {
      name: 'javascript',
      file: 'data/test_javascript.json'
    },
    {
      name: 'law',
      file: 'data/test_law.json'
    },
    {
      name: 'management',
      file: 'data/test_management.json'
    },
    {
      name: 'nursing',
      file: 'data/test_nursing.json'
    },
    {
      name: 'pharmacy',
      file: 'data/test_pharmacy.json'
    },
    {
      name: 'science',
      file: 'data/test_science.json'
    }
  ]
  exams.each do |value|
    file = File.read(value[:file])
    questions = JSON.parse(file)
    Exam.create(skill_name: value[:name], name: value[:name], questions: questions, uid: value[:file])
  end
end
