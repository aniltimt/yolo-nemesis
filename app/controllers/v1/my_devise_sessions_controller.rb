class V1::MyDeviseSessionsController < Devise::SessionsController 
  skip_before_filter :authenticate_by_token!, :only => [:create, :new]
  #prepend_before_filter :require_no_authentication, :only => []

  # GET /resource/sign_in
  def new
    resource = build_resource
    clean_up_passwords(resource)
    respond_with_navigational(resource, stub_options(resource)){ render_with_scope :new }
  end

  # POST /resource/sign_in
  def create
    reset_session
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    @user = resource
    @user.reset_authentication_token! if @user.authentication_token.nil?
    #respond_with resource, :location => redirect_location(resource_name, resource)
    render :template => 'v1/registrations/create', :format => :xml, :layout => false, :status => 200
    sign_out
    reset_session
  end
end
