# frozen_string_literal: true

##
# @class Api::V1::TodoController
# This class is the todo api controller.
class Api::V1::TodoController < ActionController::API
  def index
    todo = ToDo.last.line_items
    render json: { results: todo }.to_json, status: :ok
  end

  def update
    todo = ToDo.last.update_line_items!(todo_params)
    render json: { results: todo }.to_json, status: :ok
  end

  private

  def todo_params
    params.require(:line_items).each{ |li| li.permit(:remote_id, :title, :completed)}
  end
end
