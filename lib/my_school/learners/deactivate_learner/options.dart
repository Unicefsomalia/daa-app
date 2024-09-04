const delereReasonOptions = {
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
        "type": "field",
        "required": true,
        "read_only": false,
        "label": "Reason",
        "max_length": 45,
        "placeholder": "",
        "display_name": "description",
        "url": "api/v1/students-delete-reasons"
      },
      "description": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Other reason",
        "from_field": "reason",
        "show_only": "other",
        "show_only_field": "name",
        "max_length": 500
      }
    }
  }
};
