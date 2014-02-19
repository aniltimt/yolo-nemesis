class Tour < ActiveRecord::Base
  has_many :orders
  has_many :pobs_bundles

  belongs_to :client

  attr_accessible :id, :city, :name, :country, :build_id, :url, :client_id, :is_ubertour, :subtours_count

  has_many :tour_ubertours, :foreign_key => "ubertour_id"
  has_many :children, :through => :tour_ubertours, :source => :tour

  scope :top_popular, lambda { |*args| where('orders_count > 0').order('orders_count DESC').limit(args.blank? ? nil : args.pop) }
  scope :regular, -> { where('is_ubertour = ?', false) }
  scope :ubertours, -> { where('is_ubertour = ?', true) }

  include AASM

  aasm_state :initial
  aasm_state :pobs_bundled
  aasm_state :edited

  aasm_initial_state :initial

  aasm_event :pobs_bundled do
    transitions :from => [:edited, :initial], :to => :pobs_bundled
  end

  aasm_event :touch do
    transitions :from => [:initial, :pobs_bundled, :edited], :to => :edited
  end

  def get_last_pobs_bundle
    self.pobs_bundles.sort{|n,m| n.id <=> m.id}.last
  end
end
