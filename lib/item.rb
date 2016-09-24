class Item
  attr_reader :name, :status, :id

  def initialize(name:, id:, status: :todo)
    @name   = name
    @id     = id
    @status = status
  end

  def todo?
    status == 'todo'
  end

  def done?
    status == 'done'
  end

  def in_progress?
    status == 'in_progress'
  end
end
