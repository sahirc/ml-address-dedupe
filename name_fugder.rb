#!/usr/bin/env ruby
require 'csv'    

class String
  def initial
    self[0,1]
	end
end

csv_text = File.read('./names.csv')
csv = CSV.parse(csv_text, :headers => false)

CSV.open("fudged_named.csv", "wb") do |dest|
  csv.each do |row|
	  fname,lname = row[0].split
  	  dest << ["#{fname} #{lname}"]
    	dest << ["#{fname.initial} #{lname}"]
      dest << ["#{fname} #{lname.initial}"]
      dest << ["#{fname.initial}. #{lname}"]
  end
end