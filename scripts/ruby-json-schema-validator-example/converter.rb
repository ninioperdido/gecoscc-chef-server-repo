require 'json'
recipe = ""
resource = ""
resource_js = {
}

complete_js = {
  "description" => "GECOS workstation management LWRPs json-schema",
  "id" => "http://gecos-server/cookbooks/gecos_ws_mgmt/0.2.0/network-schema#",
  "required" => ["gecos_ws_mgmt"],
  "type" => "object",
  "properties" => {
    "gecos_ws_mgmt" => {
      "type" => "object",
        recipe => {
          "type" => "object",
          "properties" => {
            resource => resource_js
          }
        }
    }
  }
}

File.open("json_schema.json", 'w') { |file| file.write(complete_js.to_json) }
