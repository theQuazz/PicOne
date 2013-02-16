class PhotosController < ApplicationController
  before_filter :find_photo, only: [:show, :edit, :update, :destroy]
  before_filter :find_collection, only: [:index, :create]

  # url: user_collection_photos_url(user, collection)
  # GET /users/:user_id/collections/:collection_id/photos
  # GET /users/:user_id/collections/:collection_id/photos.json
  def index
    @photos = @collection.photos

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @photos }
    end
  end

  # url: user_collection_photo_url(user, collection, photo)
  # GET /users/:user_id/collections/:collection_id/photos/:id
  # GET /users/:user_id/collections/:collection_id/photos/:id.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @photo }
    end
  end

  # url: new_user_collection_photo_url(user, collection)
  # GET /users/:user_id/collections/:collection_id/photos/new
  # GET /users/:user_id/collections/:collection_id/photos/new.json
  def new
    @photo = Photo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @photo }
    end
  end

  # url: edit_user_collection_photo_url(user, collection, photo)
  # GET /users/:user_id/collections/:collection_id/photos/:id/edit
  def edit
  end

  # no url or path, this is only from forms
  # POST /users/:user_id/collections/:collection_id/photos
  # POST /users/:user_id/collections/:collection_id/photos.json
  def create
    @photo = Photo.new(params[:photo])
    @photo.collection = @collection

    respond_to do |format|
      if @photo.save
        format.html { redirect_to [@photo.user, @collection, @photo], notice: 'Photo was successfully created.' }
        format.json { render json: @photo, status: :created, location: @photo }
      else
        format.html { render action: "new" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # no url or path, this is only for forms
  # PUT /users/:user_id/collections/:collection_id/photos/:id
  # PUT /users/:user_id/collections/:collection_id/photos/:id.json
  def update
    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        format.html { redirect_to [@photo.user, @collection, @photo], notice: 'Photo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # url: delete_user_collection_photo_url(user, collection, photo)
  # DELETE /users/:user_id/collections/:collection_id/photos/:id
  # DELETE /users/:user_id/collections/:collection_id/photos/:id.json
  def destroy
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to user_collection_photos_url(@photo.user, @photo.collection) }
      format.json { head :no_content }
    end
  end


  private


  def find_collection
    @collection = Collection.find params[:collection_id]
  end

  def find_photo
    @photo = Photo.find params[:id]
  end
end
