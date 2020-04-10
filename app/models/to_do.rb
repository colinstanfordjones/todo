# frozen_string_literal: true

##
# @class ToDo
# This class is the ToDo model.
class ToDo < ApplicationRecord
  has_many :line_items, autosave: true

  def update_line_items!(items)
    updated_items = []
    items.each do |i|
      item = LineItem.find_by(id: i[:remote_id]) || LineItem.new
      item.completed = i[:completed]
      item.title = i[:title]
      updated_items.push item
    end

    if update!(line_items: updated_items)
      line_items
    end
  end
end
