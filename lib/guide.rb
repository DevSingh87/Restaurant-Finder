######### Restaurant Finder ##########
######################################
####### Code by Devendra Kumar #######
### techiedev1987@gmail.com, rubyrails.dev1987@gmail.com ###
######### +91 880 228 8284 ###########


require 'restaurant'
require 'support/string_extend'
class Guide
 
   class Config
    @@actions = ['list', 'find', 'add', 'quit']
    def self.actions; @@actions; end
   end

   def initialize(path=nil)
      #locate the restaurant text file at path
	  Restaurant.filepath = path
	  if Restaurant.file_usable?
	    puts "Restaurant file found."
		
	  #or create a new file
	  elsif Restaurant.create_file
	    puts "Restaurant file created."
	  
	  #exit if create fails
	  else 
	    puts "Exiting.\n\n"
	    exit!
	  end
     
     
   end

   def launch!
      #introduction of the app
      introduction

      #action loop, what a user wants to do?(list, find, add, quit)
      #repear until user quits
    result = nil
    until result == :quit
      action, args = get_action
      result = do_action(action, args)
    end
      #conclusion of the app
      conclusion
   end
   
   def get_action
    action = nil
    # Keep asking for user input until we get a valid action
    until Guide::Config.actions.include?(action)
      puts "Actions: " + Guide::Config.actions.join(", ")
      print "> "
      user_response = gets.chomp
      args = user_response.downcase.strip.split(' ')
      action = args.shift
    end
    return action, args
  end
  
   def do_action(action, args=[])
    case action
    when 'list'
      list(args)
    when 'find'
      keyword = args.shift
      find(keyword)
    when 'add'
      add
    when 'quit'
      return :quit
    else
      puts "\nI don't understand that command.\n"
    end
  end

  def list(args=[])
    sort_order = args.shift
    sort_order = args.shift if sort_order == 'by'
    sort_order = "name" unless ['name', 'location', 'cuisine', 'item' 'price'].include?(sort_order)
    
    output_action_header("Listing restaurants")
    
    restaurants = Restaurant.saved_restaurants
    restaurants.sort! do |r1, r2|
      case sort_order
      when 'name'
        r1.name.to_s.downcase <=> r2.name.to_s.downcase
	  when 'location'
        r1.location.to_s.downcase <=> r2.location.to_s.downcase
      when 'cuisine'
        r1.cuisine.to_s.downcase <=> r2.cuisine.to_s.downcase
	  when 'item'
        r1.item.to_s.downcase <=> r2.item.to_s.downcase
      when 'price'
        r1.price.to_i <=> r2.price.to_i
      end
    end
    output_restaurant_table(restaurants)
    puts "Sort using: 'list cuisine' or 'list by cuisine'\n\n"
  end
  
  def find(keyword="")
    output_action_header("Find a restaurant")
    if keyword
      restaurants = Restaurant.saved_restaurants
      found = restaurants.select do |rest|
        rest.name.to_s.downcase.include?(keyword.to_s.downcase) || 
		rest.location.to_s.downcase.include?(keyword.to_s.downcase) || 
        rest.cuisine.to_s.downcase.include?(keyword.to_s.downcase) || 
		rest.item.to_s.downcase.include?(keyword.to_s.downcase) || 
        rest.price.to_i <= keyword.to_i
      end
      output_restaurant_table(found)
    else
      puts "Find using a key phrase to search the restaurant list."
      puts "Examples: 'find samosa', 'find Chinese', 'find china'\n\n"
    end
  end
  
  def add
    output_action_header("Add a restaurant")
    restaurant = Restaurant.build_using_questions
    if restaurant.save
      puts "\nRestaurant Added\n\n"
    else
      puts "\nSave Error: Restaurant not added\n\n"
    end
  end
  
   def introduction
      puts "\n\n<<< Welcome to the Restaurant Finder >>>\n\n"
      puts "This application can help you to find a Restaurant for you.\n\n"
   end

   def conclusion
      puts "\n<<< Goodbye! Thank you for using this applicaiton. >>>\n\n\n"
   end
   
   private
	
   def output_action_header(text)
	  puts "\n#{text.upcase.center(80)}\n\n"
   end
	
   def output_restaurant_table(restaurants=[])
    print " " + "Name".ljust(15)
	print " " + "Location".ljust(22)
    print " " + "Cuisine".ljust(15)
	print " " + "Food Item".ljust(13)
    print " " + "Price".rjust(6) + "\n"
    puts "-" * 80
    restaurants.each do |rest|
      line =  " " << rest.name.to_s.titleize.ljust(15)
	  line << " " + rest.location.to_s.titleize.ljust(22)
      line << " " + rest.cuisine.to_s.titleize.ljust(15)
	  line << " " + rest.item.to_s.titleize.ljust(13)
      line << " " + rest.formatted_price.rjust(6)
      puts line
    end
    puts "No listings found" if restaurants.empty?
    puts "-" * 80
  end

end