# Row64 MQTT Location Client iOS



<img width="593" height="515" alt="r64_mqtt_client_image" src="https://github.com/user-attachments/assets/211f90e9-150c-497d-bb81-c6210672a2c5" />

<br><br>

The Row64 Location Client for iOS is an open-source Swift application that periodically queries the current location of an iOS device and streams the coordinates to an MQTT broker.

This application attempts to query the device's current location every five seconds and send the latitude and longitude coordinates to an MQTT broker. The MQTT message payload follows the following formatting:

* LATITUDE, LONGITUDE

For example:

* 34.054908, -118.242643



## Message Topic

This application sends MQTT messages with the topic: *R64_LOCATION_UPDATE*. To receive location updates to your broker, please ensure you are subscribed to this topic.



## MQTT Versions

This application can connect to a broker using either version 5 or 3.1.1. When a user attempts to establish a connection to a broker, the application first attempts to connect using MQTT 5. If the connection fails, the application automatically rolls back and attempts the connection using MQTT 3.1.1. A true connection failure occurs if a connection fails with both versions. Users do not need to specify the MQTT version in the application, as the application automatically identifies the highest compatible version with the targeted broker.



## Connection and Authentication Options

To connect to an MQTT broker, users must provide a valid host and port, in addition to a username and password if their broker requires authentication. The client permits flexible username and password authentication combinations. Currently, the following options are supported:

* No authentication (anonymous authentication)
* Username-only authentication
* Basic authentication (username and password)

*Users must currently connect over port 8883 (MQTT over TLS/SSL). At this time, using other ports may result in a connection failure.*



## App Permissions

Location must be enabled on the hosting device. If the user does not grant adequate permissions, the application will not work. When running the application for the first time, users will be prompted to grant permissions after connecting to a broker and attempting to send a location signal. Application permissions can always be managed and updated in the iOS system settings.

In addition to granting location permissions, the device must also have an Internet connection (Wi-Fi or cellular) to send MQTT messages to the receiving broker.



## Basic Usage

1. Ensure the host device has location services enabled and a connection to the Internet (Wi-Fi or cellular).
2. Connect to an MQTT broker by providing the connection details. At a minimum, provide a valid host and port number. If your broker requires authentication, input the username and password as needed. Select the *Connect* button to attempt a connection.
3. If a connection attempt is successful, the *Send location updates* button will become enabled. Simply select this button to begin sending periodic location updates to the connected MQTT broker.
4. When running the application for the first time, the application will pause and ask the user for location permissions. Grant permission for location. If permissions are denied, the application will not work. If needed, users can manage and upgrade the application's permission level from the iOS system settings.
5. The application will send location updates indefinitely until the *Stop sending updates* button is selected or the application is closed. A user can stop sending location updates, while maintaining a connection to the broker, by selecting the *Stop sending updates* button. Alternatively, a user can simultaneously stop sending updates and disconnect from the broker by selecting the *Disconnect* button.

