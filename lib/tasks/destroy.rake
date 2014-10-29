namespace :destroy do
  desc "Destroy everything"
  task all: :environment do
    Dir[Rails.root.join('app/models/*.rb').to_s].each do |filename|
      klass = File.basename(filename, '.rb').camelize.constantize
      next unless klass.ancestors.include?(ActiveRecord::Base)
      klass.destroy_all
    end
  end

  desc "Destroy all collections"
  task collections: :environment do
    Collection.destroy_all
  end

  desc "Destroy all items"
  task items: :environment do
    Item.destroy_all
  end

end
