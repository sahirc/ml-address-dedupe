#!/usr/bin/env ruby
require 'csv'    
require 'securerandom'

def get_rand_char
  return ([*('A'..'Z'),*('0'..'9')]-%w(0 1 I O)).sample(1).join
end

def fudge_address addrLineOne
    if addrLineOne.include? "St."
      addrLineOne = addrLineOne.sub(/St./) { "Street" }
    elsif addrLineOne.include? "Ave."
      addrLineOne = addrLineOne.sub(/Ave./) { "Avenue" }
    else 
      addrLineOne[rand(addrLineOne.length)] = get_rand_char
      addrLineOne[rand(addrLineOne.length)] = get_rand_char
    end  
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

    addrLineOne = fudge_address addrLineOne

    # Swap two letters on addressLineOne
    dest << [addrLineOne, city, state, zip, num]
    # Phone number with hypehns in 3-3-4 format
    dest << [addrLineOne, city, state, zip, "#{num.insert(3, '-').insert(7, '-')}"]
    # Remove City
    dest << [addrLineOne, "", state, zip, "#{num}"]

    cnt = cnt + 1
  end
end

