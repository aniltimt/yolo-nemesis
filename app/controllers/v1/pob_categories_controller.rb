class V1::PobCategoriesController < ApplicationController
  skip_before_filter :authenticate_by_token!

  def index
    @pob_categories = PobCategory.not_draft
    @roots = PobCategory.not_draft.root

    respond_to do |format|
      format.xml { render }
    end
  end
end
