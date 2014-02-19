@pob_categories_grouped = @pob_categories.group_by { |t| t.parent_id }

xml.instruct!

xml.categories do
  @pob_categories.each do |pob_category|
    xml.category(:id => pob_category.id, :parent_id => pob_category.parent_id, :name => pob_category.name)
  end

  xml.tree do |tree|
    @roots.each do |root|
      tree.category(:id => root.id) do
        if ! @pob_categories_grouped[root.id].blank?
          @pob_categories_grouped[root.id].each do |subcategory|
            tree.category(:id => subcategory.id)
          end
        end
      end
    end
  end
end
