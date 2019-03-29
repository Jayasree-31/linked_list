# require 'active_support'
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
      find_tail.next = Node.new(value)
    else
      @head = Node.new(value)
    end
    @cache.write('linked_list', @head)
  end
  def find_tail
    node = @head
    return node if !node.next
    return node if !node.next while (node = node.next)
  end
  def append_after(target, value)
    node           = find(target)
    return unless node
    old_next       = node.next
    node.next      = Node.new(value)
    node.next.next = old_next
  end

  def find(value)
    node = @head
    return false if !node.next
    return node  if node.value == value
    while (node = node.next)
      return node if node.value == value
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
    @cache.write('linked_list',node)
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
      node.value["data"] = data
      @cache.write('linked_list',node)
      return
    end
    while (node = node.next)
      if node.value["position"] == position
        node.value["data"] = data
        @cache.write('linked_list',node)
        return 
      end
    end
  end

  def find_list(position)
    node = @head
    return node if node.value[:position] == position
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
