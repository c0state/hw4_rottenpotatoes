# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  @movies_count = 0
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
    @movies_count += 1
  end
  # add one more for header row
  @movies_count += 1
end

Then /^I should see all of the movies$/ do
  row_count = 0
  all(:xpath, "//tr").each { |tr| 
    row_count += 1
  }
  assert @movies_count == row_count, "Not all movies listed"
end

Then /^I should see none of the movies$/ do
  row_count = 0
  all(:xpath, "//tr").each { |tr| 
    row_count += 1
  }
  # one row for the header
  assert row_count == 1, "Some movies listed"
end

# Make sure that one string (regexp) occurs before or after another one on the same page
Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  assert page.body =~ /#{e1}.*#{e2}/m, "#{e1} not before #{e2}"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check all ratings/ do |uncheck|
  check_string = uncheck ? :uncheck : :check
  step %Q{I #{check_string} the following ratings: G, PG, PG-13, R, NC-17}
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  check_string = uncheck ? :uncheck : :check
  rating_list.strip.split(/ *, */).each { |rating|
    step %Q{I #{check_string} "ratings_#{rating}"}
  }
end

Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |movie, director|
  step %Q{I should see "#{director}"}
end
