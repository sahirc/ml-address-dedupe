#!/usr/bin/env ruby
require 'csv'    

def levenshtein_distance(s, t)
  if s == nil
    s = ""
  end
  if t == nil
    t = ""
  end 

  m = s.length
  n = t.length
  return m if n == 0
  return n if m == 0
  d = Array.new(m+1) {Array.new(n+1)}

  (0..m).each {|i| d[i][0] = i}
  (0..n).each {|j| d[0][j] = j}
  (1..n).each do |j|
    (1..m).each do |i|
      d[i][j] = if s[i-1] == t[j-1]  # adjust index into string
                  d[i-1][j-1]       # no operation required
                else
                  [ d[i-1][j]+1,    # deletion
                    d[i][j-1]+1,    # insertion
                    d[i-1][j-1]+1,  # substitution
                  ].min
                end
    end
  end
  d[m][n]
end

fudged_name_adresses_phones_text = File.read('./fudged_addr_and_numbers.csv')
fudged_name_adresses_phones_csv = CSV.parse(fudged_name_adresses_phones_text, :headers => false)

CSV.open("aml_input.csv", "wb") do |dest|
  fudged_name_adresses_phones_csv.each do |address|
    address_line_one, address_line_two, city, state, zip, phone = address

    fudged_name_adresses_phones_csv.each do |other_addresses|
      address_line_one2, address_line_two2, city2, state2, zip2, phone2 = other_addresses

      n_dist = 0 # All of a customer's addresses tend to have the same name, so name is a poor feature
      p_dist = 0 # Similar to name, a customer's number stays with them through addresses so number is not a good indicator of duplicates.

      a_dist = levenshtein_distance address_line_one, address_line_one2
      a2_dist = levenshtein_distance address_line_two, address_line_two2
      c_dist = levenshtein_distance city, city2
      s_dist = levenshtein_distance state, state2
      z_dist = levenshtein_distance zip, zip2

      dest << [a_dist, a2_dist, c_dist, s_dist, z_dist, p_dist, phone.gsub(/\-\b/, '') == phone2.gsub(/\-\b/, '')]
    end
  end
end