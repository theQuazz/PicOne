class Api::V1::PhotosController < ApiController

  before_filter :find_photo, only: [:show, :update, :destroy]

  def index
    if params[:collection_id]
      @photos = collection.photos.take(25)
    else
      @photos = current_user.photos.take(25)
    end

    respond_with @photos
  end

  def show
    respond_with @photo
  end

  def create
    @photo = collection.photos.build photo_params

    if @photo.save
      respond_with @photo, status: :created, location: @photo
    else
      respond_with { errors: @photo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @photo.update_attributes photo_params
      head :no_content
    else
      respond_with { errors: @photo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @photo.destroy

    head :no_content
  end

  private

  def find_photo
    @photo = current_user.photos.find params[:id]
  end

  def collection
    current_user.collections.find params[:collection_id]
  end

  def photo_params
    params.require(:photo).permit(:caption, :image, :location)
  end

end
