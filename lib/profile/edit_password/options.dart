const options = {
  "name": "List Create Teachers Api",
  "description": "",
  "renders": ["application/json", "text/html"],
  "parses": [
    "application/json",
    "application/x-www-form-urlencoded",
    "multipart/form-data"
  ],
  "actions": {
    "POST": {
      "old_password": {
        "type": "string",
        "required": true,
        "read_only": false,
        "label": "Old Password",
        "obscure": true,
      },
      "new_password": {
        "type": "string",
        "required": true,
        "read_only": false,
        "label": "New Password",
        "obscure": true,
      },
      "confirm_password": {
        "type": "string",
        "required": true,
        "read_only": false,
        "label": "Confirm Password",
        "obscure": true,
      }
    }
  }
};
