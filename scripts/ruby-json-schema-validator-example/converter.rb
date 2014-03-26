require 'json'
recipe = "users_mgmt"
resource = "user_apps_autostart_res"
resource_js = {
  type: "object",
  required: ["autostart_files"],
  properties: {
    autostart_files: {
      type: "array",
      minItems: 0,
      uniqueItems: true,
      items: {
        type: "object",
        required: ["user", "desktops"],
        properties: {
          user: {type: "string"},
          desktops: {
            type: "array",
            minItems: 0,
            uniqueItems: true,
            items: {type: "string"}
          }
        }
      }
    },
    job_ids: {
        type: "array",
        minItems: 0,
        uniqueItems: true,
        items: {
          type: "object",
          required: ["id"],
          properties: {
            id: { type: "string" },
            status: { type: "string" }
          }
        }
    }
  }

}

complete_js = {
  "description" => "GECOS workstation management LWRPs json-schema",
  "id" => "http://gecos-server/cookbooks/gecos_ws_mgmt/0.2.0/network-schema#",
  "required" => ["gecos_ws_mgmt"],
  "type" => "object",
  "properties" => {
    "gecos_ws_mgmt" => {
      
      "type" => "object",
      "required" => [recipe],
      "properties" => {
        recipe => {
          "type" => "object",
          "required" => [resource],
          "properties" => {
            resource => resource_js
          }
        }
      }
    }
  }
}

File.open("json_schema.json", 'w') { |file| file.write(complete_js.to_json) }
