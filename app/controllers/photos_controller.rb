class PhotosController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [:index] })

  def index
    @list_of_photos = Photo.all.order(created_at: :desc)
    render(template: "photos_html/index")
  end
end
