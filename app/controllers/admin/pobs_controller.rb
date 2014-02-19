COUNTRIES = ["Afghanistan", "Aland Islands", "Albania", "Algeria", "American Samoa", "Andorra", "Angola",
        "Anguilla", "Antarctica", "Antigua And Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria",
        "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin",
        "Bermuda", "Bhutan", "Bolivia, Plurinational State of", "Bonaire, Sint Eustatius and Saba", "Bosnia and Herzegovina",
				"Botswana", "Bouvet Island", "Brazil",
        "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia",
        "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China",
        "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Comoros", "Congo",
        "Congo, the Democratic Republic of the", "Cook Islands", "Costa Rica", "Cote d'Ivoire", "Croatia", "Cuba",
        "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "Egypt",
        "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands (Malvinas)",
        "Faroe Islands", "Fiji", "Finland", "France", "French Guiana", "French Polynesia",
        "French Southern Territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece",
				"Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guernsey", "Guinea",
        "Guinea-Bissau", "Guyana", "Haiti", "Heard Island and McDonald Islands", "Holy See (Vatican City State)",
        "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran, Islamic Republic of", "Iraq",
        "Ireland", "Isle of Man", "Israel", "Italy", "Jamaica", "Japan", "Jersey", "Jordan", "Kazakhstan", "Kenya",
        "Kiribati", "Korea, Democratic People's Republic of", "Korea, Republic of", "Kuwait", "Kyrgyzstan",
        "Lao People's Democratic Republic", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya",
        "Liechtenstein", "Lithuania", "Luxembourg", "Macao", "Macedonia, The Former Yugoslav Republic Of",
        "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique",
        "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia, Federated States of", "Moldova, Republic of",
        "Monaco", "Mongolia", "Montenegro", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru",
        "Nepal", "Netherlands", "New Caledonia", "New Zealand", "Nicaragua", "Niger",
        "Nigeria", "Niue", "Norfolk Island", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau",
        "Palestinian Territory, Occupied", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines",
        "Pitcairn", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion", "Romania", "Russian Federation",
        "Rwanda", "Saint Barthelemy", "Saint Helena, Ascension and Tristan da Cunha", "Saint Kitts and Nevis", "Saint Lucia",
        "Saint Martin (French Part)", "Saint Pierre and Miquelon", "Saint Vincent and the Grenadines", "Samoa", "San Marino",
        "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore",
        "Sint Maarten (Dutch Part)", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa",
        "South Georgia and the South Sandwich Islands", "South Sudan", "Spain", "Sri Lanka", "Sudan", "Suriname",
        "Svalbard and Jan Mayen", "Swaziland", "Sweden", "Switzerland", "Syrian Arab Republic",
        "Taiwan, Province of China", "Tajikistan", "Tanzania, United Republic of", "Thailand", "Timor-Leste",
        "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan",
        "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom",
        "United States", "United States Minor Outlying Islands", "Uruguay", "Uzbekistan", "Vanuatu",
				"Venezuela, Bolivarian Republic of", "Viet Nam", "Virgin Islands, British", "Virgin Islands, U.S.",
				"Wallis and Futuna", "Western Sahara", "Yemen", "Zambia", "Zimbabwe"]

class Admin::PobsController < Admin::ApplicationController

  before_filter :set_defaults, :only => [:create, :update, :new, :edit]

  def index
    @page = params[:page] || 1
    @pobs = Pob.includes([:pob_categories]).order('created_at DESC').paginate(:page => @page, :per_page => 30)
    @pobs_count = Pob.count
    @countries = COUNTRIES
  end

  def search
    relation = Pob.includes([:pob_categories]).order('pobs.created_at DESC')

    @pob_name = params[:pob][:name]
    @pob_country = params[:pob][:country]
    @pob_city = params[:pob][:city]
    @pob_category = params[:pob][:category]

    relation = @pob_name.blank? ? relation : relation.where(['pobs.name LIKE ?', "%#{@pob_name}%"])
    relation = @pob_category.blank? ? relation : relation.where(['pob_categories_pobs.pob_category_id IN (?)', @pob_category])
    relation = @pob_country.blank? ? relation : relation.where(['country = ?', @pob_country])
    relation = @pob_city.blank? ? relation : relation.where(['city LIKE ?', "%#{@pob_city}%"])

    @page = params[:page] || 1
    @pobs_count = relation.count
    @pobs = relation.paginate(:page => @page, :per_page => 30)
    @countries = COUNTRIES

    render :index
  end

  def show
    @pob = Pob.find params[:id]
  end

  def edit
    @pob = Pob.find params[:id]
    session[:return_to_pob] = request.env["HTTP_REFERER"]
  end

  def destroy
    @pob = Pob.find params[:id]
    if @pob.destroy
      set_flash_notice @pob, "deleted"
      redirect_to admin_pobs_url
    else
      flash[:error] = "Sorry, there were errors while deleting new Place of Business"
      redirect_to(:back)
    end
  end

  def new
    @pob = Pob.new
    session[:return_to_pob] = request.env["HTTP_REFERER"]
  end

  def update
    @pob = Pob.find(params[:id])
    if @pob.update_attributes(params[:pob])
      set_flash_notice @pob, "updated"
      redirect_to admin_pobs_url(@pob.id)
    else
      flash.now[:error] = "Sorry, there were errors while updating #{@pob.name}"
      render(:action => :edit)
    end
  end

  def create
    @pob = Pob.new(params[:pob])  
    if !@pob.save
      flash.now[:error] = "Sorry, there were errors while creating new Place of Business"
      render(:action => :new)
    else
      flash[:notice] = "You've successfully created Place of Business called #{@pob.name}"
      set_flash_notice @pob, "created"
      redirect_to admin_pobs_url(@pob.id)
    end
  end

  def remove_pob_image
    pob_image = PobImage.find_by_id(params[:pob_image_id])
    pob_image.remove_image!
    pob_image.destroy
    render :json => {:result => "ok"}.to_json    
  rescue
    render :json => {:result => "failed"}.to_json, :status => 500
  end

  def remove_pob_icon
    pob = Pob.find_by_id(params[:pob_id])
    pob.remove_icon! if pob
  end

  private

    def set_defaults
      @top_categories = PobCategory.where('parent_id IS NULL').all
      @countries = COUNTRIES
    end

    def set_flash_notice(pob, action)
        flash[:notice] = "You've successfully #{action} Place of Business called #{pob.name}. ".html_safe
        if Tour.edited.count > 0
          flash[:notice] << "<br />There is <a href='/admin/tours/pending' class='btn btn-warning'>pending</a> tours".html_safe
        end
    end
end
