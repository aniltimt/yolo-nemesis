class Admin::ToursController < Admin::ApplicationController
  NUM_OF_TOURS_PER_PAGE = 30

  before_filter :paginated_tours, :only => [:index, :show_tours]

  def index
    @tours = @tours_tmp.limit(NUM_OF_TOURS_PER_PAGE)
  end
  
  def show_tours
    @tours = @tours_tmp.limit(NUM_OF_TOURS_PER_PAGE).offset((@current_page.to_i - 1) * NUM_OF_TOURS_PER_PAGE).all # we need all here since it'll be no records displayed
  end

  def free
    @tour = Tour.find(params[:id])
    @tour.update_attribute(:free, true)
  end
  
  def paid
    @tour = Tour.find(params[:id])
    @tour.update_attribute(:free, false)
  end

  def publish
    @tour = Tour.find(params[:id])
    @tour.update_attribute(:is_published, true)
    respond_to do |format|
      format.json { render :json=> [] }
    end
  end

  def unpublish
    @tour = Tour.find(params[:id])
    @tour.update_attribute(:is_published, false)
    respond_to do |format|
      format.json { render :json=> [] }
    end
  end

  def pending
    @tours = Tour.edited
  end

  def rebuild_bundles
    @tours = Tour.find(params[:tours] || [])
    @tours.each do |tour|
      pobs_bundle = PobsBundle.find_last_by_tour_id(tour.id)
      if pobs_bundle.south && pobs_bundle.north && pobs_bundle.west && pobs_bundle.east
        pobs_bundles_categories_ids = pobs_bundle.filtered_categories

        @pobs = Pob.find_by_sql ["SELECT * FROM pobs LEFT JOIN pob_categories_pobs pcp ON pcp.pob_id = pobs.id WHERE pcp.pob_category_id IN (?) AND pobs.latitude >= #{pobs_bundle.south} AND pobs.latitude <= #{pobs_bundle.north} AND pobs.longitude >= #{pobs_bundle.west} AND pobs.longitude <= #{pobs_bundle.east} GROUP BY pobs.id", pobs_bundles_categories_ids]
        new_pobs_bundle = pobs_bundle.clone
        new_pobs_bundle.created_at = Time.now
        new_pobs_bundle.pobs = @pobs
        new_pobs_bundle.save
      end
      tour.try(:pobs_bundled!)
      tour.save
    end
    flash[:notice] = "You've successfully updated tours."
    redirect_to admin_tours_url
  end

  def filter_draft_categories
  end

  protected
    def paginated_tours
      @current_page = params[:page] || 1
      @type = params[:type] || 'all'

      @tours_tmp = case @type
        when 'regular'; Tour.regular.order("created_at DESC")
        when 'all'; Tour.order("created_at DESC")
        when 'ubertours'; Tour.ubertours.order("created_at DESC")
      end
      
      @total_tours = @tours_tmp.count
      @num_of_pages = (@total_tours / NUM_OF_TOURS_PER_PAGE.to_f).ceil
    end
end
