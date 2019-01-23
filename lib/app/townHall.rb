require 'open-uri'

class TownHall
	attr_reader :hash_townhall

	def get_townhall_email(townhall_url)
		#renvoi l'adresse email trouvé sur le site mis en argument
		page = Nokogiri::HTML(open(townhall_url))   
		page.xpath('//div/main/section[2]/div/table/tbody/tr[4]/td[2]').text
	end

	def get_townhall_urls
	#renvoi un array contenant toutes les url des sites des villes du val d'oise et un array contenant leurs noms
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
		#initialise l'attribu @hash_townhall avec un Hash contenant en key les noms des villes et en value les adresses email
		townhall_info = get_townhall_urls
		url_list = townhall_info[0]
		name_list = townhall_info[1]
		@hash_townhall = {}

		url_list.each_with_index do |townhall_url,i|
			@hash_townhall[name_list[i]] = get_townhall_email(townhall_url)
		end
		#si le site est inaccessible demain, mettre en commentaire les lignes ci-dessus et aciver les lignes ci-dessous
=begin		
		File.open("db/copie.JSON").each do |line|
			@hash_townhall = JSON.parse(line)
		end
=end

	end

	def to_s
		puts @hash_townhall
	end

	def save_as_JSON
	#enregistre l'instance de classe en format Json
		File.open("db/email.JSON","w+") do |file|
		  file.write(JSON.pretty_generate(@hash_townhall))
		end
	end

	def array_townhall
		#retourne un array à partir de l'attribu hash_townhall
		array_townhall = []
		@hash_townhall.each do |name_town,email_town| 
			array_townhall << [name_town, email_town]
		end
		return array_townhall
	end

	def save_as_csv
	#enregistre l'instance de classe en format csv
		CSV.open("db/email.csv","w+") do |csv|
			csv << ["city","email"]
		  array_townhall.each do |a|
		  	csv << a
		  end
		end
	end

	def save_as_spreadsheet
	#enregistre l'instance de classe en spreadsheet sur google-drive
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
