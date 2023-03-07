namespace :db do
  namespace :seed do
		desc 'Populate products data'

		task create_products: :environment do
			file = File.read('./products.json')
			data_hash = JSON.parse(file)

			Product.create!(data_hash['products'])
		end
	end
end