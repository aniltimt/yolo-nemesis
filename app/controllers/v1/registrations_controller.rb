class V1::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :authenticate_by_token!, :only => [:create, :new, :sign_up]
  prepend_before_filter :require_no_authentication, :only => []

  def new
    super
    if !@user.errors.empty?
      render :status => 401
    end
  end

  def create
    build_resource

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => redirect_location(resource_name, resource)
      else
        set_flash_message :notice, :inactive_signed_up, :reason => inactive_reason(resource) if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords(resource)
      respond_with_navigational(resource) { render :template => "v1/registrations/new", :status => 401 } # render_with_scope :new
    end
  end
end
