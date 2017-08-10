#!/usr/bin/env ruby
# Compiles a minimart inventory that automatically includes all tags for
# specified github repos, to avoid having to add them manually.
require 'pp'
require 'octokit'
require 'yaml'

def parse_definition(yaml_tags)
  if yaml_tags.is_a? String
    {
      'repo' => yaml_tags,
      'exclude_tags' => []
    }
  else
    yaml_tags
  end
end


basedir        = File.expand_path(File.join(File.dirname(__FILE__), '..'))
base_file      = File.join(basedir, 'inventory_base.yml')
inventory_file = File.join(basedir, 'inventory.yml')

puts "Building from base inventory in #{basedir}"

inventory = YAML.load_file(base_file)

puts "Identifying cookbook repos to auto-generate"
auto_cookbooks = inventory['cookbooks'].select do | cookbook_name, cookbook_def |
  ! cookbook_def['github-tags'].nil?
end

puts "Loading tags for auto-generating repos"
auto_cookbooks.each do | cookbook_name, cookbook_def |
    config = parse_definition(cookbook_def['github-tags'])
    repo   = Octokit::Repository.new(config['repo'])
    puts " - #{cookbook_name} => #{repo.url}"
    tag_names     = []
    Octokit.tags(repo).map{|tag| tag.name}.reverse.each do | tag_name |
      if config['exclude_tags'].include? tag_name
        puts " -- !EXCLUDE! #{tag_name}"
      else
        puts " -- #{tag_name}"
        tag_names << tag_name
      end
    end
    inventory['cookbooks'][cookbook_name]['git'] = {
      'location' => repo.url,
      'tags' =>tag_names
    }
end

puts "Generating compiled #{inventory_file}"
File.write(inventory_file, "# Auto-compiled from #{base_file}\n"+inventory.to_yaml)
puts "Inventory file created OK"

