require 'rubygems'
require 'json'

print "Enter your github username: "
username = gets.chomp
print "Enter your github password: "
password = gets.chomp

puts ""
puts "Loading your contribution statistics..."

ownerUrl = "https://api.github.com/user/repos"
authenticationString = "#{username}:#{password}"
projectsString = `curl -H "Accept: application/json" -X GET #{ownerUrl} -u #{authenticationString} --silent`

projectsHash = JSON.parse(projectsString)
projectContributions = Hash.new

totalDeletions = 0
totalAdditions = 0
total          = 0

statsHash = Hash.new

projectsHash.each do |project|
	projectName = project["name"]
	statsUrl = "https://api.github.com/repos/#{username}/#{projectName}/stats/contributors"

	statsString = `curl -H "Accept: application/json" -X GET #{statsUrl} -u #{authenticationString} --silent`
	projectStats = JSON.parse(statsString)
	
	projectStatsHash = projectStats[0]

	if projectStatsHash["author"]["login"] == "#{username}"
		statsHash["#{projectName}"] = {"additions" => 0, "deletions" => 0, "subtotal" => 0}
			
		weeklyContributions = projectStatsHash["weeks"]
		weeklyContributions.each do |statisticsHash|
			currentAdditions = statsHash["#{projectName}"]["additions"]
			currentDeletions = statsHash["#{projectName}"]["deletions"]
			statsHash["#{projectName}"]["additions"] = currentAdditions + statisticsHash["a"].to_i
			statsHash["#{projectName}"]["deletions"] = currentDeletions + statisticsHash["d"].to_i
		end
		subtotal = statsHash["#{projectName}"]["additions"] - statsHash["#{projectName}"]["deletions"]
		statsHash["#{projectName}"]["subtotal"] = subtotal
	end
	
	totalDeletions = totalDeletions + statsHash["#{projectName}"]["deletions"]
	totalAdditions = totalAdditions + statsHash["#{projectName}"]["additions"]
	total          = total          + statsHash["#{projectName}"]["subtotal"]
end

statsHash["all projects"] = {"additions" => "#{totalAdditions}", "deletions" => "#{totalDeletions}", "subtotal" => "#{total}"}
statsHash.each do |projectName, stats|
	additions  = stats["additions"]
	deletions  = stats["deletions"]
	difference = stats["subtotal"]

	puts ""
	puts "Stats for #{projectName}:"
	puts "	Additions  : #{additions}"
	puts "	Deletions  : #{deletions}"
	puts "	Difference : #{difference}"
end




