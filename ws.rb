require 'csv'
require 'yaml'

require 'sinatra'

set :bind, '0.0.0.0'

config       = YAML.load_file(ARGV.first)
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

get "/main.js" do
  content_type "text/javascript"
  erb "main.js".to_sym, locals: {
    lang: config[:client][:lang],
    autostart: config[:client][:autostart],
    form_names: config[:client][:form_names],
    commands: config[:client][:commands]
  }
end

get ?/ do
  erb "index.htm".to_sym, locals: {
    autostart: config[:client][:autostart],
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

if params.key? "save" then
  csv.flush
else

  if not type.nil? and not types.include?(type)then
    types << type
    File.write(types_file, types.to_yaml)
  end

  if not parent.nil? and not parents.include?(parent) then
    parents << parent
    File.write(parents_file, parents.to_yaml)
  end

  if type == config[:server][:type_storage] then
    parents << name
    File.write(parents_file, parents.to_yaml)
  end

  csv.puts [name, type, parent, comment] unless name.to_s.empty?

  data[:type]   = type||data[:type]
  data[:parent] = parent||data[:parent]
end

  erb "index.htm".to_sym, locals: {
    autostart: config[:client][:autostart],
    types: types, parents: parents,
    type: data[:type].to_s, parent: data[:parent].to_s
  }
end


