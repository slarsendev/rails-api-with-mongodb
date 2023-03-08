namespace :db do
  namespace :seed do
		desc 'Populate products data'

		task create_products: :environment do
			file = File.read('./products.json')
			data_hash = JSON.parse(file)

			data_hash['products'].each do |product|
			  p = Product.new(product)
				p.save(validate: false)
			end
		end
	end
end