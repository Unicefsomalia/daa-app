const teachersOptions = {
  "name": "List Create Teachers Dynamics Api",
  "description": "Group statistics by:\n`type` = id, shehiya, district, region",
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
      "username": {
        "type": "string",
        "required": false,
        "read_only": true,
        "label": "Username"
      },
      "gender_name": {
        "type": "string",
        "required": false,
        "read_only": true,
        "label": "Gender name"
      },
      "gender": {
        "type": "string",
        "required": false,
        "read_only": true,
        "label": "Gender"
      },
      "role": {
        "type": "string",
        "required": false,
        "read_only": true,
        "label": "Role"
      },
      "role_name": {
        "type": "string",
        "required": false,
        "read_only": true,
        "label": "Role name"
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
      "first_name": {
        "type": "alphabets",
        "required": true,
        "read_only": false,
        "label": "First Name",
        "max_length": 45
      },
      "middle_name": {
        "type": "alphabets",
        "required": false,
        "read_only": false,
        "label": "Middle Name",
        "max_length": 45
      },
      "last_name": {
        "type": "alphabets",
        "required": true,
        "read_only": false,
        "label": "Last Name",
        "max_length": 45
      },
      "date_started_teaching": {
        "type": "date",
        "required": false,
        "read_only": false,
        "label": "Date started teaching"
      },
      "joined_current_school": {
        "type": "date",
        "required": false,
        "read_only": false,
        "label": "Joined current school"
      },
      "is_non_delete": {
        "type": "boolean",
        "required": false,
        "read_only": false,
        "label": "Is non delete"
      },
      "active": {
        "type": "boolean",
        "required": false,
        "read_only": false,
        "label": "Active"
      },
      "type": {
        "type": "choice",
        "required": false,
        "read_only": false,
        "label": "Teacher Type",
        "choices": [
          {"value": "E", "display_name": "Employed"},
          {"value": "V", "display_name": "Volunteer"}
        ]
      },
      "employment_id": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Employment id",
        "max_length": 45,
        "show_only": "E",
        "from_field": "type",
      },
      "employed_by": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Employed by",
        "max_length": 45,
        "show_only": "E",
        "from_field": "type",
      },
      "phone": {
        "type": "integer",
        "required": true,
        "read_only": false,
        "label": "Phone Number",
        "max_length": 20,
        "placeholder": "Will be used as the username to login"
      },
      "qualifications": {
        "type": "choice",
        "required": false,
        "read_only": false,
        "label": "Qualifications",
        "choices": [
          {"value": "NS", "display_name": "Not Set"},
          {"value": "UNI", "display_name": "UNIVERSITY"},
          {"value": "COL", "display_name": "COLLEGE"}
        ]
      },
      "is_school_admin": {
        "type": "boolean",
        "required": false,
        "read_only": false,
        "label": "Is School Admin?"
      },
      "email": {
        "type": "email",
        "required": false,
        "read_only": false,
        "label": "Email Address",
        "max_length": 100
      },
      "marital_status": {
        "type": "choice",
        "required": false,
        "read_only": false,
        "label": "Marital status",
        "choices": [
          {"value": "NS", "display_name": "Not Set"},
          {"value": "S", "display_name": "Single"},
          {"value": "M", "display_name": "Married"},
          {"value": "D", "display_name": "Divorced"}
        ]
      },
      "dob": {
        "type": "date",
        "required": false,
        "read_only": false,
        "label": "Date of Birth",
        "start_value": "1960-01-01",
        "end_value": "2008-01-01",
      },
      "moe_id": {
        "type": "string",
        "required": false,
        "read_only": false,
        "label": "Moe id",
        "max_length": 50
      },
      "user": {
        "type": "field",
        "required": false,
        "read_only": false,
        "label": "User"
      },
      "school": {
        "type": "field",
        "required": true,
        "read_only": false,
        "label": "School"
      },
      "streams": {
        "type": "multifield",
        "required": true,
        "read_only": false,
        "multiple": true,
        "storage": "classes",
        "label": "Assign Class Rooms",
        "display_name": "class_name",
        "show_only": false,
        "from_field": "is_school_admin"
      }
    }
  }
};
