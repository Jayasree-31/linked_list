class ListController < ApplicationController
  before_action :set_linked_list, :set_cache
  def index
    lists = @list.get_lists
    render json: lists
  end

  def create
    return render json: {"error": "data and position is required "} if params[:data].blank? || params[:position].blank?
    list_data = {}
    list_data["data"] = params[:data]
    list_data["position"] = params[:position]
    @list.append(list_data)
    render json:  {"message": "Node created successfully"}
  end

  def show
    list = @list.find_list(params[:id])
    render json: list
  end

  def update
    list_data = {}
    list_data["data"] = params[:data]
    list_data["position"] = params[:position]
    @list.update_list(params[:id], list_data)
    render json: {"message": "Node updated successfully" }
  end

  def destroy
    @list.delete(params[:id])
    render json: {"message": "Node deleted successfully"}
  end

  private
  def set_cache
    @cache = ActiveSupport::Cache::FileStore.new "/tmp/linked_list_cache"
  end

  def set_linked_list
    @list = LinkedList.new
  end
end
