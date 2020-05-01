require 'csv'
require 'yaml'

require 'sinatra'

set :bind, '0.0.0.0'

types_file   = 'types.yaml';
parents_file = 'parents.yaml';
data = {
  name: nil,
  type: nil,
  parent: nil,
  comment: nil,
}

types   = if File.exist?(types_file) then
            YAML.load_file(types_file).compact
          else
            []
          end
parents = if File.exist?(parents_file) then
            YAML.load_file(parents_file).compact
          else
            []
          end
csv     = CSV.open("warehouse.csv", ?a)

trap(:INT) {
  csv.close
  Sinatra::Base.quit!
}

get ?/ do
  erb "index.htm".to_sym, locals: {
    types: types, parents: parents,
    type: data[:type].to_s, parent: data[:parent].to_s
  }
end

post ?/ do
  p params
  name    = params["name"]   
  type    = params["type"]   
  parent  = params["parent"] 
  comment = params["comment"]


  if not type.nil? and not types.include?(type)then
    types << type
    File.write(types_file, types.to_yaml)
  end

  if not parent.nil? and not parents.include?(parent) then
    parents << parent
    File.write(parents_file, parents.to_yaml)
  end

  if type == "収納" then
    parents << name
    File.write(parents_file, parents.to_yaml)
  end

  csv.puts [name, type, parent, comment] unless name.to_s.empty?

  data[:type]   = type||data[:type]
  data[:parent] = parent||data[:parent]

  erb "index.htm".to_sym, locals: {
    types: types, parents: parents,
    type: data[:type].to_s, parent: data[:parent].to_s
  }
end


