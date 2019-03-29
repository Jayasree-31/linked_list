class ListController < ApplicationController
  # ::MEMORY_STORE = ActiveSupport::Cache::MemoryStore.new
  def index
  end

  def create
    
    append({data: {"key1": "value1"}, position: 2})
    cache = ActiveSupport::Cache::FileStore.new "/tmp/linked_list_cache"
    linked_list = cache.read('linked_list')
    render json: {"linked_list": linked_list}
  end

  def show
    render json: {  }
  end

  def update
  end

  def delete
  end

  private
  def append(value)
    cache = ActiveSupport::Cache::FileStore.new "/tmp/linked_list_cache"
      cache.write('linked_list', value)
  end

end
