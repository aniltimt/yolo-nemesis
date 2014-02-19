class Admin::ClientsController < Admin::ApplicationController
  NUM_OF_USERS_PER_PAGE = 50
  include ERB::Util

  skip_before_filter :request_auth, :only => [:check_validity]

  def index
    @clients = Client.all
    @client = Client.new
  end

  def create
    @client = Client.new :name => params[:user_name], :email => params[:email_address], :merge_existing_user => (params[:merge_user] == 'true')
    if @client.save
      # automatically creates user with preview rights on after_save action
      flash[:notice] = "The client #{h params[:user_name]} was successfully created. It'll be available in Tour Builder after 5 minutes"
      if ! request.xhr?
        redirect_to admin_client_path(@client.id)
      end
    end
  end

  def check_validity
    @client = Client.new :name => params[:user_name], :email => params[:email_address]
    @client.valid?
  end

  def check_email_validity
    if params[:client_id]
      @client = Client.find params[:client_id]
    end

    @message = if params[:email_address].blank?
      "<li>Email can't be blank</li>"
    elsif params[:email_address] !~ Client::EMAIL_PATTERN
      "<li>Email is invalid</li>"
    elsif (!@client && Client.find_by_email(params[:email_address])) || (@client && params[:email_address] != @client.email && Client.find_by_email(params[:email_address]))
      "<li>Email has already been taken</li>"
    end
  end

  def check_name_validity
    if params[:client_id]
      @client = Client.find params[:client_id]
    end

    @message = if params[:user_name].blank?
      "<li>Name can't be blank</li>"
    elsif (!@client && Client.find_by_name(params[:user_name])) || (@client && params[:user_name] != @client.name && Client.find_by_name(params[:user_name]))
      "<li>Name has already been taken</li>"
    end
  end

  def check_password_validity
    @message = if params[:user_password].to_s.length < 6
      "<li>Password is too short (minimum is 6 characters)</li>"
    end
  end

  def edit
    @client = Client.find params[:id]
    @available_tours = Tour.all
    @client_tour_ids = @client.tours.collect{|t| t.id}

    @current_page = 1
    @num_of_pages = (@client.users.count / NUM_OF_USERS_PER_PAGE.to_f).ceil
    @client_users = @client.users.order("created_at DESC").limit(NUM_OF_USERS_PER_PAGE)
  end

  def show
    @client = Client.find params[:id]
    @available_tours = Tour.all
    @client_tour_ids = @client.tours.collect{|t| t.id}

    @current_page = 1
    @num_of_pages = (@client.generated_users.count / NUM_OF_USERS_PER_PAGE.to_f).ceil
    @client_users = @client.generated_users.order("created_at DESC").limit(NUM_OF_USERS_PER_PAGE)
  end

  def update
    @client = Client.find params[:id]
    if @client.update_attributes(params[:client])
      @client.reload
      preview_user = @client.preview_user
      preview_user.email = @client.email
      preview_user.password = @client.password
      preview_user.save
      flash[:notice] = "The client's record was successfully updated! All changes will be applied in Tour Builder after 5 minutes"

      if ! request.xhr?
        redirect_to admin_client_path(@client.id)
      end
    end
  end

  def destroy
    @client = Client.find params[:id]
    if @client.destroy
      redirect_to admin_clients_path, :notice => "The client '#{@client.name}' was successfully deleted"
    else
      redirect_to admin_client_path(@client.id), :error => "There were some errors while deleting specified client"
    end
  end

  def generate_users
    client = Client.find params[:id]
    client_domain = client.email.match(/.*@(.*)/)[1]
    Rails.logger.warn 'cl match ' + client.email.match(/.*@(.*)/).inspect
    client.update_attribute(:last_generation_index, (client.last_generation_index + 1))
    client.reload
    symbols = ["A".."Z", "a".."z", 1..9].map(&:to_a).flatten
    params[:quantity].to_i.times do |i|
      user = User.new
      user.name = symbols.sample(10).join
      user.email = "#{user.name}@#{client_domain}"
      user.password = user.name
      user.generation_index = client.last_generation_index
      user.save

      client.users << user
    end
    redirect_to admin_client_path(client.id)
  end

  def save_tours
    client = Client.find params[:id]

    if ! params[:tour_id].blank?
      params[:tour_id].each do |tour_id|
        tour = Tour.find(tour_id)
        tour.update_attribute :client_id, client.id
      end
    else
      client.tours.each{|tour| tour.update_attribute :client_id, nil}
    end
    redirect_to admin_client_path(client.id)
  end

  def show_users
    @client = Client.find params[:id]
    @current_page = params[:page]
    @num_of_pages = (@client.generated_users.count / NUM_OF_USERS_PER_PAGE.to_f).ceil
    @client_users = @client.generated_users.order("created_at DESC").limit(NUM_OF_USERS_PER_PAGE).offset((@current_page.to_i - 1) * NUM_OF_USERS_PER_PAGE)
  end

  def download_csv_userlist
    require 'csv'
    client = Client.find params[:id]

    if params[:generation].blank?
      client_users = client.users.without_preview
    else
      client_users = client.users.without_preview.generation(params[:generation])
    end

    if RUBY_VERSION.split('.')[1] == '9'
      csv_str = CSV::generate() do |csv|
        client_users.each do |user|
          csv << [user.email, user.name, user.created_at.to_s(:db)]
        end
      end
      send_data csv_str, :filename => "#{client.name}_users_list_#{Time.now.to_date}.csv"
    else
      f = String.new
      CSV::Writer.generate(f) do |csv|
        client_users.each do |user|
          csv << [user.email, user.name, user.created_at.to_s(:db)]
        end
      end
      send_data f, :filename => "#{client.name}_users_list_#{Time.now.to_date}.csv"
    end
  end

  def download_pdf_userlist
    client = Client.find params[:id]
    client.users.each do |user|
    end
  end
end
