name              "gecos_workstation_management"
maintainer        "Roberto C. Morano"
maintainer_email  "rcmorano@emergya.com"
license           "Apache 2.0"
description       "Cookbook for GECOS workstations miscelaneous administration"
version           "0.2.0"


%w{ ubuntu debian }.each do |os|
  supports os
end

# more complete input definition via json-schema:
js = Hash.new
js["id"] = "http://some.site.somewhere/entry-schema#"
# TODO: provide a valid schema URL
#js["$schema"] = "http://github.com/gecos-team/networkmanagement-cookbook/json-schemas/root-schema#"
js["description"] = "GECOS chef-client-management-cookbook attributes json-schema"
js["type"] = "object"
js["required"] = [ "gecos_workstation_management" ]
js["properties"] = Hash.new
js["properties"]["gecos_workstation_management"] = Hash.new
js["properties"]["gecos_workstation_management"]["type"] = "object"
js["properties"]["gecos_workstation_management"]["required"] = ["default_recipe"]

js["properties"]["gecos_workstation_management"]["default_recipe"] = Hash.new
js["properties"]["gecos_workstation_management"]["default_recipe"]["type"] = "object"
js["properties"]["gecos_workstation_management"]["default_recipe"]["required"] = ["setup_system_upgrades_resource"]

js["properties"]["gecos_workstation_management"]["default_recipe"]["setup_system_upgrades_resource"] = Hash.new
js["properties"]["gecos_workstation_management"]["default_recipe"]["setup_system_upgrades_resource"]["type"] = "object"
js["properties"]["gecos_workstation_management"]["default_recipe"]["setup_system_upgrades_resource"]["required"] = ["net"]

js["properties"]["gecos_workstation_management"]["default_recipe"]["setup_system_upgrades_resource"]["enabled"] = Hash.new
js["properties"]["gecos_workstation_management"]["default_recipe"]["setup_system_upgrades_resource"]["enabled"]["type"] = "boolean"

js["properties"]["gecos_workstation_management"]["default_recipe"]["setup_system_upgrades_resource"]["interval"] = Hash.new
js["properties"]["gecos_workstation_management"]["default_recipe"]["setup_system_upgrades_resource"]["interval"]["type"] = "integer"
js["properties"]["gecos_workstation_management"]["default_recipe"]["setup_system_upgrades_resource"]["interval"]["minimum"] = 3600

attribute 'json_schema',
  :display_name => "json-schema",
  :description  => "Special attribute to include json-schema for defining cookbook's input",
  :type         => "hash",
  :object       => js

