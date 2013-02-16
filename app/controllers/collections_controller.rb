class CollectionsController < ApplicationController
  before_filter :find_collection, only: [:show, :edit, :update, :destroy]
  before_filter :find_user, only: [:index, :create]

  # url: user_collections_url(user)
  # GET /users/:user_id/collections
  # GET /users/:user_id/collections.json
  def index
    @collections = @user.collections

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @collections }
    end
  end

  # url: show_user_collection_url(user, collection)
  # GET /users/:user_id/collections/:id
  # GET /users/:user_id/collections/:id.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @collection }
    end
  end

  # url: new_user_collection_url(user)
  # GET /users/:user_id/collections/new
  # GET /users/:user_id/collections/new.json
  def new
    @collection = Collection.new
    @collection.user = @user

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @collection }
    end
  end

  # url: edit_user_collection_url(user, collection)
  # GET /users/:user_id/collections/:id/edit
  def edit
  end

  # no url or path, this is only from forms
  # POST /users/:user_id/collections
  # POST /users/:user_id/collections.json
  def create
    @collection = Collection.new(params[:collection])
    @collection.user = @user

    respond_to do |format|
      if @collection.save
        format.html { redirect_to [@collection.user, @collection], notice: 'Collection was successfully created.' }
        format.json { render json: @collection, status: :created, location: @collection }
      else
        format.html { render action: "new" }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # no url or path, this is only from forms
  # PUT /users/:user_id/collections/:id
  # PUT /users/:user_id/collections/:id.json
  def update
    respond_to do |format|
      if @collection.update_attributes(params[:collection])
        format.html { redirect_to [@collection.user, @collection], notice: 'Collection was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end


  # no url or path, this is only from forms
  # DELETE /users/:user_id/collections/:id
  # DELETE /users/:user_id/collections/:id.json
  def destroy
    @collection.destroy

    respond_to do |format|
      format.html { redirect_to user_collections_url(@collection.user) }
      format.json { head :no_content }
    end
  end


  private

  def find_user
    @user = User.find params[:user_id]
  end

  def find_collection
    @collection = Collection.find params[:id]
  end
end
