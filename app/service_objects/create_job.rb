# frozen_string_literal: true

class CreateJob
  attr_reader :params, :user

  def initialize(current_user, params = {})
    @params = params
    @user = current_user
  end

  def call
    job = Job.new(user_id: user.id)
    job.update_attributes(params.except(:categories))
    job.categories << Category.where('lower(name) = ?', params[:categories]
                              .map(&:downcase))
    job.save!
    job.reload
  end
end
