class PobCategory < ActiveRecord::Base
  validates_presence_of :name

  has_and_belongs_to_many :pobs

  attr_accessible :id, :name, :parent_id, :is_draft

  scope :not_draft, where("is_draft = false")
  scope :root, where("parent_id IS NULL")

  def parent
    if self.parent_id
      PobCategory.find self.parent_id
    end
  end

  def subcategories
    self.class.where(['parent_id = ?', self.id])
  end
end
