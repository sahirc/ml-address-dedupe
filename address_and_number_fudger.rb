#!/usr/bin/env ruby
require 'csv'    
require 'securerandom'

def get_rand_char
  return ([*('A'..'Z'),*('0'..'9')]-%w(0 1 I O)).sample(1).join
end

def fudge_address addrLineOne
    if (rand(10000) % 2 == 0)
      if addrLineOne.include? "St."
        addrLineOne = addrLineOne.sub(/St./) { "Street" }
      elsif addrLineOne.include? "Ave."
        addrLineOne = addrLineOne.sub(/Ave./) { "Avenue" }
      end 
    end 

    if (rand(10000) % 2 == 0)
      if addrLineOne.include? "N."
        addrLineOne = addrLineOne.sub(/N./) { "North" }
      elsif addrLineOne.include? "S."
        addrLineOne = addrLineOne.sub(/Ave./) { "South" }
      elsif addrLineOne.include? "E."
        addrLineOne = addrLineOne.sub(/Ave./) { "East" }
      elsif addrLineOne.include? "W."
        addrLineOne = addrLineOne.sub(/Ave./) { "West" }
      end             
    end 

    i  = rand (5)
    while i >= 0
      addrLineOne[rand(addrLineOne.length)] = get_rand_char
      i = i - 1
    end 

    return addrLineOne 
end

class String
  def initial
    self[0,1]
  end
end

addr_text = File.read('./addresses.csv')
phone_text = File.read('./numbers.csv')
addr_csv = CSV.parse(addr_text, :headers => false)
phone_csv = CSV.parse(phone_text, :headers => false)

cnt = 0
CSV.open("fudged_addr_and_numbers.csv", "wb") do |dest|
  addr_csv.each do |addr_row|
    addrLineOne,city,state,zip , = addr_row
    num = phone_csv[cnt][0]
    
    # Accurate address
    dest << [addrLineOne, city, state, zip, num]

    dest << [fudge_address(addrLineOne), city, state, zip, num]

    # Phone number with hypehns in 3-3-4 format
    dest << [fudge_address(addrLineOne), city, state, zip, "#{num.insert(3, '-').insert(7, '-')}"]
    
    # Remove City
    dest << [fudge_address(addrLineOne), "", state, zip, "#{num}"]

    cnt = cnt + 1
  end
end

