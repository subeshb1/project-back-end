class CategorySerializer < ActiveModel::Serializer
  attributes :name, :image

  def image
    return nil unless object.image.attached?

    ENV['URL'] + Rails.application.routes.url_helpers.rails_blob_path(object.image,
                                                                      only_path: true)
  end
end
