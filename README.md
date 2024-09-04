# **Digital Attendance Application - Flutter Application**

## **Introduction**
Digital Attendance is an open-source project supported by UNICEF Somalia through a collaboration with [Sisitech](https://sisitech.com). The platform allows tracking of individual student attendance in schools.

It is comprised of three components:
- **API**: Django Rest Framework 
- **Dashboard**: Angular Web Application 
- **Application**: Flutter Android Application (this project)

## **Digital Attendance Journey**
- [Digital Attendance Journey Journey](https://drive.google.com/file/d/17T3VT-howD86XOSYrExLVMXWiXTiXimD/view)

## **Docker Swarm Deployment Documentation**
- [Deployment Docs](https://deploy.daasomalia.com/)

---

## **Flutter Setup Guide**

### **1. Cloning the Project**
```bash
git clone https://github.com/Unicefsomalia/daa-app.git
```

Navigate into the project directory:

```bash
cd daa-app
```

---

### **2. Installing the Packages**
Ensure that you have the required Flutter packages installed by running the following command in your project directory:

```bash
flutter pub get
```

This will install all the dependencies specified in your `pubspec.yaml` file.

---

### **3. Creating the `.jks` Keystore File**

Before setting up the `key.properties` file, you need to create a Java Keystore (`.jks`) file. Follow these steps:

1. **Open a terminal** and run the following command to generate a `.jks` keystore file:

   ```bash
   keytool -genkey -v -keystore SomKey.jks -keyalg RSA -keysize 2048 -validity 10000 -alias somapp
   ```

2. **Fill in the required details**, such as:
   - **Keystore Password:** Choose a secure password for the keystore.
   - **Key Password:** You will need this later for the `key.properties` file.
   - **Alias:** In this example, we use `somapp` for the alias.

3. **Move the Keystore File**: Once the `.jks` file is generated, move it to the `Keys` directory in your project:

   ```bash
   mv SomKey.jks ../../Keys/
   ```

**Important:**  
Make sure **NOT** to commit the `.jks` keystore file or `key.properties` to version control (e.g., Git). Add the following entries to your `.gitignore` file:

```bash
# Keystore files
**/android/key.properties
**/Keys/*.jks
```

---

### **4. Setting Up the Keys**

After creating the `.jks` keystore, configure your keys as follows:

1. **Create the `key.properties` file** in your Android directory with the following content:

   ```properties
   storePassword=your_store_password_example  # Example: somapp123
   keyPassword=your_key_password_example      # Example: somapp123
   keyAlias=your_key_alias_example            # Example: somapp
   storeFile=../../Keys/YourKeyFile.jks       # Example: ../../Keys/SomKey.jks
   ```

   Replace the placeholder values with your actual passwords and file paths.

2. **Store File Location:**
   Ensure that your `.jks` file is located in the `Keys` directory, which is two levels above the `android` folder (`../../Keys/SomKey.jks`). If the location differs, update the `storeFile` path accordingly.

---

### **5. Update the APIConfig in `main.dart`**

In your `main.dart` file, update the `APIConfig` with the necessary values. Here’s the structure of the `APIConfig`:

```dart
APIConfig(
  apiEndpoint: "", // Specify the API base URL
  version: "api/v1", // Define the API version
  clientId: "", // Insert the generated client ID here
  tokenUrl: 'o/token/', // Specify the OAuth token URL
  grantType: "password", // Set the grant type
  revokeTokenUrl: 'o/revoke_token/' // URL to revoke tokens
);
```

---

### **6. Generating `client_id` from Django Admin**

To generate the `client_id` for your application:

1. **Access the Django Admin:**
   - Login to the Django admin interface.
   - Ensure you have the necessary permissions to manage OAuth clients.

2. **Create a New OAuth Client:**
   - Navigate to the **OAuth2 Provider** section.
   - Click on **Applications** and select **Add Application**.
   
3. **Configure the Application:**
   - **Name:** Provide a name for your application (e.g., "FlutterApp").
   - **Client ID:** Leave this field empty, as it will be generated automatically.
   - **Client Secret:** This will also be generated automatically.
   - **Redirect URIs:** Add any valid URIs that your Flutter application may use.
   - **Client Type:** Set to **Public**.
   - **Authorization Grant Type:** Choose **Resource Owner Password-Based**.
   
4. **Save and Retrieve the `client_id`:**
   - After saving, the `client_id` and `client_secret` will be generated.
   - Use the `client_id` in your Flutter application's `APIConfig`.

---

## **Want to Contribute or Have Any Questions?**
We welcome contributions and feedback! If you want to contribute to this project or have any questions, reach out via email at hello@sisitech.com

