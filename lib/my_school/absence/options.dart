// ignore: constant_identifier_names
const AbsenceReasonOptions = {
  "name": "List Create Absent Reasons Api",
  "description": "",
  "renders": ["application/json", "text/html"],
  "parses": [
    "application/json",
    "application/x-www-form-urlencoded",
    "multipart/form-data"
  ],
  "actions": {
    "POST": {
      "id": {
        "type": "integer",
        "required": false,
        "read_only": true,
        "label": "ID"
      },
      "school_name": {
        "type": "string",
        "required": false,
        "read_only": true,
        "label": "School name"
      },
      "created": {
        "type": "datetime",
        "required": false,
        "read_only": true,
        "label": "Created"
      },
      "modified": {
        "type": "datetime",
        "required": false,
        "read_only": true,
        "label": "Modified"
      },
      "name": {
        "type": "string",
        "required": true,
        "read_only": false,
        "label": "Name",
        "max_length": 45
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
      },
      "reason": {
        "type": "field",
        "required": true,
        "read_only": false,
        "label": "Reason",
        "max_length": 45,
        "placeholder": "",
        "display_name": "description",
        "url": "api/v1/students-absent-reasons",
      }
    }
  }
};
