# frozen_string_literal: true

##
# @class ToDo
# This class is the ToDo model.
class ToDo < ApplicationRecord
  has_many :line_items

  def update_line_items!(items)
    updated_items = []
    items.each do |i|
      item = LineItem.find_by(id: i[:id]) || LineItem.new
      item.completed = i[:completed]
      item.title = i[:title]
      updated_items.push item
    end

    update!(line_items: updated_items)
  end
end
