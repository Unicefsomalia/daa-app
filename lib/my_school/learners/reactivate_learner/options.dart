const reactivateLearnerOptions = {
  "name": "List Create Shops Api",
  "description": "",
  "renders": ["application/json", "text/html"],
  "parses": [
    "application/json",
    "application/x-www-form-urlencoded",
    "multipart/form-data"
  ],
  "actions": {
    "POST": {
      "reason": {
        "type": "string",
        "required": true,
        "read_only": false,
        "label": "Reason",
        "max_length": 500,
      },
      "stream": {
        "type": "field",
        "required": true,
        "read_only": false,
        "label": "Class",
        "storage": "classes",
        "display_name": "class_name"
      },
    }
  }
};
