class Admin::UsersController < Admin::ApplicationController
  NUM_OF_USERS_PER_PAGE = 30

  before_filter :paginated_users, :only => [:index, :show_users]

  def index
    @users = @users_tmp.limit(NUM_OF_USERS_PER_PAGE)
  end

  def show_users
    @users = @users_tmp.limit(NUM_OF_USERS_PER_PAGE).offset((@current_page.to_i - 1) * NUM_OF_USERS_PER_PAGE).all # we need all here since it'll be no records displayed
  end

  protected
    def paginated_users
      @current_page = params[:page] || 1
      @type = params[:type] || 'registered'
      
      @users_tmp = case @type
        when 'registered'; User.registered.order("created_at DESC")
        when 'all'; User.order("created_at DESC")
        when 'generated'; User.generated.order("created_at DESC")
      end
      
      @total_users = @users_tmp.count
      @num_of_pages = (@total_users / NUM_OF_USERS_PER_PAGE.to_f).ceil
    end
end
