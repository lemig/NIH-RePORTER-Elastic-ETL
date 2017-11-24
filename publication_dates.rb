

min_date = Date.new(1980,1,1)
min_date = Date.new(2015,1,1)
max_date = Date.today

day_triplets = (min_date..max_date).map{ |d| [d.year, d.month, d.day] };
month_triplets = day_triplets.select{|d| d[2] == 1 };
year_triplets = month_triplets.select{|d| d[1] == 1 };
years = year_triplets.map(&:first);


season_triplets = {
  'Winter' => [1970, 12, 22],
  'Spring' => [1970, 3, 22],
  'Summer' => [1970, 6, 22],
  'Fall' => [1970, 9, 22]
}

seasons = season_triplets.keys


h = {}

# "2007-2008" => [2007,1,1]
year_triplets.each do |year_triplet|
  date = Date.new *year_triplet
  key = "#{date.year}-#{date.next_year.year}"
  h[key]  = year_triplet
end

# "2007 Dec-2008 Jan" => [2007,12,1]
# "2010 Nov-2011 Jan" => [2010,11,1]
month_triplets.each do |month_triplet|
  date = Date.new *month_triplet
  key1 = "#{date.strftime('%Y %b')}-#{date.next_month.strftime('%Y %b')}"
  key2 = "#{date.strftime('%Y %b')}-#{date.next_month.next_month.strftime('%Y %b')}"
  h[key1]  = month_triplet
  h[key2]  = month_triplet
end

# "2007 Spring-Summer" => [2007,3,22]
# "2013 Summer-Winter" => [2013,6,22]
years.each do |year|
  seasons.combination(2).each do |season1, season2|
    season_triplet = season_triplets[season1]
    triplet = [year, season_triplet[1], season_triplet[2]]
    key = "#{year} #{season1}-#{season2}"
    h[key]  = triplet
  end
end

# "2007-2008 Winter" => [2007,12,22]
years.each do |year|
  triplet = [year, 12, 22]
  key = "#{year}-#{year + 1} Winter"
  h[key]  = triplet
end

# "2015 Third Quarter" => [2015,7,1]
years.each do |year|
  h["#{year} First Quarter"]   = [year, 1, 1]
  h["#{year} Second Quarter"]  = [year, 4, 1]
  h["#{year} Third Quarter"]   = [year, 7, 1]
  h["#{year} Fourth Quarter"]  = [year, 10, 1]
  h["#{year} 1st Quarter"]     = [year, 1, 1]
  h["#{year} 2nd Quarter"]     = [year, 4, 1]
  h["#{year} 3rd Quarter"]     = [year, 7, 1]
  h["#{year} 4th Quarter"]     = [year, 10, 1]
end









