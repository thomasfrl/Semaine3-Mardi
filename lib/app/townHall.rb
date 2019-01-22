require 'open-uri'

class TownHall
	attr_reader :hash_townhall

	def get_townhall_email(townhall_url)
		page = Nokogiri::HTML(open(townhall_url))   
		page.xpath('//div/main/section[2]/div/table/tbody/tr[4]/td[2]').text
	end

	def get_townhall_urls
		town_name =[]
		town_url = []
		page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))   
		page.xpath('//a[@class="lientxt"]').each do |link|
		  town_name <<  link.text
		  town_url << "http://annuaire-des-mairies.com" + link["href"][1..-1]
		end
		return [town_url, town_name]
	end


	def initialize
=begin
		townhall_info = get_townhall_urls
		url_list = townhall_info[0]
		name_list = townhall_info[1]

		url_list.each_with_index do |townhall_url,i|
			@hash_townhall[name_list[i]] = get_townhall_email(townhall_url)
		end
=end
		File.open("db/copie.JSON").each do |line|
			@hash_townhall = JSON.parse(line)
		end

	end

	def to_s
		puts @hash_townhall
	end

	def save_as_JSON
		File.open("db/email.JSON","w+") do |line|
		  line.write(@hash_townhall.to_json)
		end
	end

	def save_as_csv
		array_townhall = []
		@hash_townhall.each do |name_town,email_town| 
			array_townhall << [name_town, email_town]
		end

		CSV.open("db/email.csv","w+") do |csv|
			csv << ["city","email"]
		  array_townhall.each do |a|
		  	csv << a
		  end
		end
	end

	def save_as_spreadsheet
		array_townhall = []
		@hash_townhall.each do |name_town,email_town| 
			array_townhall << [name_town, email_town]
		end

		session = GoogleDrive::Session.from_config("config.JSON")
		spread_sheet = session.create_spreadsheet("liste email des mairies")
		ws = spread_sheet.worksheets[0]

		array_townhall.each_with_index do |townhall,i|
			ws[i+1,1] = townhall[0]
			ws[i+1,2] = townhall[1]
		end	
		ws.save
	end
end
