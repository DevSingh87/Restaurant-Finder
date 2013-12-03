######### Restaurant Finder ##########
######################################
####### Code by Devendra Kumar #######
### techiedev1987@gmail.com, rubyrails.dev1987@gmail.com ###
######### +91 880 228 8284 ###########

APP_ROOT = File.dirname(__FILE__)

# require "#{APP_ROOT}/lib/guide"
# require File.join(APP_ROOT, 'lib', 'guide.rb')
# require File.join(APP_ROOT, 'lib', 'guide')

$:.unshift( File.join(APP_ROOT, 'lib') )
require 'guide'

guide = Guide.new('restaurants.txt')
guide.launch!
