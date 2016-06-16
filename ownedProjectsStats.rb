require 'rubygems'
require 'json'

puts "Enter your github username: "
username = gets.chomp
puts "Enter your github password: "
password = gets.chomp

ownerUrl = "https://api.github.com/user/repos"
authenticationString = "#{username}:#{password}"
projectsString = `curl -i #{url} -u #{authenticationString}`

projectsHash = JSON.parse(jsonString)
projectContributions = Hash.new

#TODO: needs to be tested and fixed
projectsHash.each do |project|
	projectName = project["name"]
	statsUrl = "https://api.github.com/repos/#{username}/#{projectName}/stats/contributors"

	statsString = `curl -i #{statsUrl} -u #{authenticationString}`
	projectStats = JSON.parse(contributorsString)

	statsHash = Hash.new

	projectStats.each do |contributor|
		if contributor["author"].equals("username")
			statsHash["#{projectName}"] = Hash.new
			statsHash["#{projectName}"]["additions"] = 0;
			statsHash["#{projectName}"]["deletions"] = 0;
			statsHash["#{projectName}"]["subtotal"] = 0;

			weeklyContributions = contributor["weeks"]
			weeklyContributions.each do |statitisticsHash|
				statsHash["projectName"]["additions"] += statisticsHash["a"].to_i
				statsHash["projectName"]["deletions"] += statisticsHash["d"].to_i
			end
			statsHash["#{projectName}"]["subtotal"] = thisProjectAdditions - thisProjectDeletions
		end

		statsHash.each do |projectNames|
			deletions+=statsHash["#{projectName}"]["deletions"]
			additions+=statsHash["#{projectName}"]["additions"]
			total+=statsHash["#{projectName}"]["subtotal"]
		end

		statsHash["total"] = total
	end

	statsHash.each do |stats|
		#TODO: here's where we output everything
	end
end





