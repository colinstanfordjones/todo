# frozen_string_literal: true

##
# @class LineItem
# This class is the LineItem model.
class LineItem < ApplicationRecord
  belongs_to :to_do
end
