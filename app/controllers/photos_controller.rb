class PhotosController < ApplicationController
  skip_before_action(:authenticate_user!, only: [:index, :show])
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @list_of_photos = Photo.all.order(created_at: :desc)
    render(template: "photos_html/index")
  end

  def show
    my_photo_id = params.fetch("photo_id")
    @the_photo = Photo.find_by(id: my_photo_id)

    if @the_photo.nil?
      redirect_to("/404")
    else
      render(template: "photos_html/show")
    end
  end

  def delete
    my_photo_id = params.fetch("photo_id")
    the_photo = Photo.find_by(id: my_photo_id)

    if the_photo
      the_photo.destroy
      redirect_to("/photos", notice: "Photo deleted successfully.")
    else
      redirect_to("/photos", alert: "Photo not found.")
    end
  end

  def create
    # Safely fetch parameters
    image = params[:input_image]
    caption = params[:input_caption]

    # Handle missing fields
    if image.blank? || caption.blank?
      redirect_to("/photos", alert: "Both image and caption are required.") and return
    end

    # Create the photo
    new_photo = Photo.new(image: image, caption: caption, owner_id: current_user.id)

    if new_photo.save
      redirect_to("/photos/#{new_photo.id}", notice: "Photo created successfully.")
    else
      redirect_to("/photos", alert: "Failed to create photo. Please try again.")
    end
  end

  def update
    my_photo_id = params.fetch("photo_id")
    the_photo = Photo.find_by(id: my_photo_id)

    if the_photo
      the_photo.caption = params[:input_caption] if params[:input_caption]
      the_photo.image = params[:input_image] if params[:input_image]

      if the_photo.save
        redirect_to("/photos/#{my_photo_id}", notice: "Photo updated successfully.")
      else
        redirect_to("/photos/#{my_photo_id}", alert: "Failed to update photo.")
      end
    else
      redirect_to("/photos", alert: "Photo not found.")
    end
  end

  def comment
    input_photo_id = params.fetch("input_photo_id")
    input_comment = params.fetch("input_comment")

    new_comment = Comment.new(
      body: input_comment,
      author_id: current_user.id,
      photo_id: input_photo_id
    )

    if new_comment.save
      redirect_to("/photos/#{input_photo_id}", notice: "Comment added successfully!")
    else
      redirect_to("/photos/#{input_photo_id}", alert: "Failed to add comment. Please try again.")
    end
  end

  def like
    @photo = Photo.find_by(id: params[:id])

    if @photo.nil?
      redirect_to("/photos", alert: "Photo not found.") and return
    end

    if @photo.fans.include?(current_user)
      redirect_to("/photos/#{@photo.id}", alert: "You already liked this photo!")
    else
      @photo.likes.create(fan: current_user)
      redirect_to("/photos/#{@photo.id}", notice: "Like created successfully.")
    end
  end

  def unlike
    @photo = Photo.find_by(id: params[:id])

    if @photo.nil?
      redirect_to("/photos", alert: "Photo not found.") and return
    end

    like = @photo.likes.find_by(fan: current_user)
    if like
      like.destroy
      redirect_to("/photos/#{@photo.id}", notice: "Like removed successfully.")
    else
      redirect_to("/photos/#{@photo.id}", alert: "You haven't liked this photo yet!")
    end
  end
end
