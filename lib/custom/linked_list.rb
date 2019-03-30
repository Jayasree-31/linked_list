class LinkedList
  def initialize
    @cache = ActiveSupport::Cache::FileStore.new "/tmp/linked_list_cache"
    lists = @cache.read('linked_list')
    if lists.blank?
      @head = nil
    else
      @head = lists
    end
  end
  def append(value)
    if @head
      append_after(value)
    else
      @head = Node.new(value)
    end
    @cache.write('linked_list', @head)
  end
  def append_after(value)
    node = @head
    if !node.next
      if value["position"].to_i < node.value["position"].to_i
        @head = Node.new(value)
        @head.next = node
        return
      else
        node.next = Node.new(value)
        return
      end
    else
      intial_node = node
      previous_node = nil
      if value["position"].to_i < node.value["position"].to_i
        @head = Node.new(value)
        @head.next = node
        return
      end
      check = false
      while (node = node.next)
        if value["position"].to_i < node.value["position"].to_i
          if previous_node.nil?
            @head.next = Node.new(value)
            @head.next.next = node
            return
          else
            check = true
            previous_node.next = Node.new(value)
            previous_node.next.next = node
            return
          end
        elsif node.next.nil? && !check
          node.next = Node.new(value)
          return
        end
        previous_node = node
      end
    end
  end

  def delete(position)
    if @head.value["position"] == position
      @head = @head.next
      @cache.write('linked_list', @head)
      return
    end
    node      = find_before(position)
    node.next = node.next.next
    @cache.write('linked_list',@head)
  end

  def find_before(position)
    node = @head
    return false if !node.next
    return node  if node.next.value["position"] == position
    while (node = node.next)
      return node if node.next && node.next.value["position"] == position
    end
  end

  def update_list(position, data)
    node = @head
    if node.value["position"] == position
      node.value["data"] = data["data"]
      @cache.write('linked_list',@head)
      return
    end
    while (node = node.next)
      if node.value["position"] == position
        node.value["data"] = data["data"]
        @cache.write('linked_list',@head)
        return 
      end
    end
  end

  def find_list(position)
    node = @head
    return node.value if node.value["position"] == position
    while (node = node.next)
      return node.value if node.value["position"] == position
    end
  end

  def get_lists
    data = []
    node = @head
    return [] if node.nil?
    data << node.value
    while (node = node.next)
      data << node.value
    end
    data
  end
end
