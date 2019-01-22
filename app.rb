require 'bundler'
Bundler.require
$LOAD_PATH.unshift(File.expand_path('./../lib', __FILE__))
require 'app/townHall.rb'

list_email =  TownHall.new
#créé une instance de la classe TownHall et lui applique des methodes
list_email.save_as_JSON
list_email.save_as_csv
list_email.save_as_spreadsheet
