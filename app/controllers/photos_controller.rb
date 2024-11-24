class PhotosController < ApplicationController
  skip_before_action(:authenticate_user!, { :only => [:index] })

  def index
    @list_of_photos = Photo.all.order(created_at: :desc)
    render(template: "photos_html/index")
  end

  def show
    my_photo_id = params.fetch("photo_id")
    @the_photo = Photo.where(id: my_photo_id).first

    if @the_photo == nil
      redirect_to("/404")
    else
      render(template: "photos_html/show")
    end
  end

  def delete
    my_photo_id = params.fetch("photo_id")
    the_photo = Photo.where(id: my_photo_id).first
    the_photo.destroy
    # render(template: "photos_html/delete")
    redirect_to("/photos")
  end

  def create
    # Ensure all necessary parameters are fetched safely
    image = params[:input_image]
    caption = params[:input_caption]

    # Check for missing parameters
    if image.blank? || caption.blank?
      flash[:alert] = "All fields are required to create a photo."
      redirect_to("/photos") and return
    end

    # Create the new photo
    new_photo = Photo.new
    new_photo.image = image
    new_photo.caption = caption

    flash[:notice] = "Photo created successfully."
    redirect_to("/photos/" + new_photo.id.to_s)
  end

  def update
    my_photo_id = params.fetch("photo_id")
    caption = params.fetch("input_caption")
    image = params.fetch("input_image")
    the_photo = Photo.where(id: my_photo_id).first
    the_photo.caption = caption
    the_photo.image = image
    the_photo.save
    redirect_to("/photos/" + my_photo_id)
  end

  def comment
    input_photo_id = params.fetch("input_photo_id")
    input_author_id = params.fetch("input_author_id")
    input_comment = params.fetch("input_comment")

    new_comment = Comment.new
    new_comment.body = input_comment
    new_comment.author_id = input_author_id
    new_comment.photo_id = input_photo_id

    if new_comment.save
      redirect_to "/photos/#{input_photo_id}", notice: "Comment added successfully!"
    else
      redirect_to "/photos/#{input_photo_id}", alert: "Failed to add comment. Please try again."
    end
  end

  def add_comment
    input_photo_id = params.fetch("input_photo_id")
    input_author_id = params.fetch("input_author_id")
    input_comment = params.fetch("input_comment")

    new_comment = Comment.new
    new_comment.body = input_comment
    new_comment.author_id = input_author_id
    new_comment.photo_id = input_photo_id

    if new_comment.save
      redirect_to "/photos/#{input_photo_id}", notice: "Comment added successfully!"
    else
      redirect_to "/photos/#{input_photo_id}", alert: "Failed to add comment. Please try again."
    end
  end

  def like
    @photo = Photo.find(params[:id])

    if @photo.fans.include?(current_user)
      redirect_to photo_path(@photo), alert: "You already liked this photo!"
    else
      @photo.likes.create(fan: current_user)
      redirect_to photo_path(@photo), notice: "Like created successfully."
    end
  end

  def unlike
    @photo = Photo.find(params[:id])

    like = @photo.likes.find_by(fan: current_user)
    if like
      like.destroy
      redirect_to photo_path(@photo), notice: "Like deleted successfully."
    else
      redirect_to photo_path(@photo), alert: "You haven't liked this photo yet!"
    end
  end
end
