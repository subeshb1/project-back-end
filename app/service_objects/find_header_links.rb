# frozen_string_literal: true

class FindHeaderLinks
  attr_reader :request_params, :request_env, :current_page, :last_page

  def initialize(request_params, request_env, current_page, last_page)
    @request_params = request_params
    @request_env = request_env
    @current_page = current_page
    @last_page = last_page
  end

  def call
    url_without_params = fetch_url_without_params
    requested_page = request_params[:page].to_i
    page = arrange_page_order(requested_page)
    pagination_links = page.map do |key, val|
      new_request_hash = request_params.merge(page: val)
      "<#{url_without_params}?#{new_request_hash.to_param}>; rel=\"#{key}\""
    end
    pagination_links.join(', ')
  end

  private

  def fetch_url_without_params
    rack_url = request_env['rack.url_scheme']
    "#{rack_url}://#{request_env['HTTP_HOST']}#{request_env['PATH_INFO']}"
  end

  def arrange_page_order(requested_page)
    page = {}
    if requested_page > 1
      page[:first] = 1
      page[:prev] = [current_page - 1, last_page].min
    end
    page[:next] = current_page + 1 if requested_page < last_page
    page[:last] = last_page if requested_page != last_page
    page
  end
end
