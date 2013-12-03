######### Restaurant Finder ##########
######################################
####### Code by Devendra Kumar #######
### techiedev1987@gmail.com, rubyrails.dev1987@gmail.com ###
######### +91 880 228 8284 ###########

require 'support/number_helper'
class Restaurant
  include NumberHelper

  @@filepath = nil
  def self.filepath=(path=nil)
    @@filepath = File.join(APP_ROOT, path)
  end
  
  attr_accessor :name, :location, :cuisine, :item, :price
  
  def self.file_exists?
    # class should know if the restaurant file exists
    if @@filepath && File.exists?(@@filepath)
      return true
    else
      return false
    end
  end
  
  def self.file_usable?
    return false unless @@filepath
    return false unless File.exists?(@@filepath)
    return false unless File.readable?(@@filepath)
    return false unless File.writable?(@@filepath)
    return true
  end
  
  def self.create_file
    # create the restaurant file
    File.open(@@filepath, 'w') unless file_exists?
    return file_usable?
  end
  
  def self.saved_restaurants
    # We have to ask ourselves, do we want a fresh copy each 
    # time or do we want to store the results in a variable?
    restaurants = []
    if file_usable?
      file = File.new(@@filepath, 'r')
      file.each_line do |line|
        restaurants << Restaurant.new.import_line(line.chomp)
      end
      file.close
    end
    return restaurants
  end

  def self.build_using_questions
    args = {}
    print "Restaurant name: "
    args[:name] = gets.chomp.strip
    
	print "Location: "
    args[:location] = gets.chomp.strip
	
    print "Cuisine type: "
    args[:cuisine] = gets.chomp.strip
	
	print "Food item: "
    args[:item] = gets.chomp.strip
    
    print "Average price: "
    args[:price] = gets.chomp.strip
    
    return self.new(args)
  end
  
  def initialize(args={})
    @name     = args[:name]     || ""
	@location = args[:location] || ""
    @cuisine  = args[:cuisine]  || ""
	@item     = args[:item]     || ""
    @price    = args[:price]    || ""
  end
  
  def import_line(line)
    line_array = line.split("\t")
    @name, @location, @cuisine, @item, @price = line_array
    return self
  end
  
  def save
    return false unless Restaurant.file_usable?
    File.open(@@filepath, 'a') do |file|
      file.puts "#{[@name, @location, @cuisine, @item, @price].join("\t")}\n"
    end
    return true
  end
  
  def formatted_price
    number_to_currency(@price)
  end
  
end