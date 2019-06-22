# frozen_string_literal: true

class UpdateJob
  attr_reader :job,:params

  def initialize(job, params={})
    @params=params
    @job = job
  end

  def call
    params = fetch_attributes
    job.update_attributes(params.except(:categories))
    if params[:categories]
      job.categories.destroy_all
      job.categories << Category.where(name: params[:categories])
    end
    job.reload
  end

  private

  def fetch_attributes
    params[:status] = Job::STATUS.key(params[:status]) if params[:status] && Job::STATUS.key(params[:status])
    params
  end
end
