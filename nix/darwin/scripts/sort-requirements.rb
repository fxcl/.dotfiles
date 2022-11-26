#!/usr/bin/env ruby
require "yaml"

if ARGV.length != 1
	puts "Usage: #{File.basename __FILE__} path/to/requirements.yml"
	exit 1
end

unless File.exist? ARGV.first
	puts "Error: Input file does not exist"
	exit 1
end

YAML.load_file(ARGV.first).tap do |yaml|
	if yaml.kind_of? Array
		yaml.sort! { |a, b| a["src"] <=> b["src"] }
	else
		if yaml.has_key? "roles"
			yaml["roles"].sort! { |a, b| a["src"] <=> b["src"] }
		end

		if yaml.has_key? "collections"
			yaml["collections"].sort! { |a, b| a["name"] <=> b["name"] }
		end
	end

	File.open(ARGV.first, "w+") do |file|
		file.write "# Standards: 1.2\n"
		if yaml.kind_of? Array
			file.write yaml.to_yaml
		else
			result = []

			if yaml.has_key? "collections"
				result.push({
					"collections" => yaml["collections"]
				}.to_yaml)
			end

			if yaml.has_key? "roles"
				result.push({
					"roles" => yaml["roles"]
				}.to_yaml)
			end

			file.write result.join("\n")
		end

		file.write "\n...\n"
	end
end
