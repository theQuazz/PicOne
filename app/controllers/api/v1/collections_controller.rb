class Api::V1::CollectionsController < ApiController

  before_filter :find_collection, only: [:show, :update, :destroy]

  def index
    @collections = current_user.collections.take 25

    respond_with @collections
  end

  def show
    respond_with @collection
  end

  def create
    @collection = @user.collections.build params[:collection]

    if @collection.save
      redirect_to api_v2_collection_path(@collection)
    else
      respond_with { errors: @collection.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @collection.update_attributes(params[:collection])
      head :no_content
    else
      respond_with { errors: @collection.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @collection.destroy

    head :no_content
  end

  private

  def find_collection
    @collection = current_user.collections.find params[:id]
  end

end
