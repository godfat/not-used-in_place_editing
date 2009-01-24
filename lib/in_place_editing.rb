module InPlaceEditing
  def self.included(base)
    base.extend(ClassMethods)
  end

  # Example:
  #
  #   # Controller
  #   class BlogController < ApplicationController
  #     in_place_edit_for :post, :title
  #   end
  #
  #   # View
  #   <%= in_place_editor_field :post, 'title' %>
  #
  module ClassMethods
    def in_place_edit_for(object, attribute, options = {})
      define_method("set_#{object}_#{attribute}") do
        @item = object.to_s.camelize.constantize.find(params[:id])
        # update even if params[:value] is blank string but not nil
        # update if no block given or check should we update with the block
        if !params[:value].nil? && (!block_given? || yield(self))
          @item.update_attribute(attribute, params[:value])
        end
        render :text => @item.send(attribute).to_s
      end
    end
  end
end
