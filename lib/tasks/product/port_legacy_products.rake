namespace :product do
  desc "Assign first category to all legacy products without a category"
  task :port_legacy_products => [:environment] do
    category = Category.first
    if category
      updated_products = Product.where(category: nil).update!(category: category)
      puts "#{updated_products.size} number of legacy products have been updated"
    end
  end
end
