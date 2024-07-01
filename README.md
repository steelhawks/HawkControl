<h1 align="center">Steel Hawks: HawkControl</h1>

![Static Badge](https://img.shields.io/badge/Team-2601-red?style=for-the-badge&link=https%3A%2F%2Fsteelhawks.org)

# HawkControl

HawkControl is an FRC (FIRST Robotics Competition) robotics dashboard designed to control robots from Apple devices. It is written in Swift and is optimized for iPad and Mac, but it can also be used on iPhone. HawkControl utilizes NetworkTables for communication and includes a client proxy script to handle NetworkTables interactions, as there is no native NetworkTables library for Swift. Additionally, the app features a watchdog for safety.

## Features

- **Cross-Platform Compatibility:** Works on iPad, Mac, and iPhone, Android possibly later via [Skip](https://skip.tools/)
- **NetworkTables Integration:** Communicates with the robot using NetworkTables.
- **Client Proxy:** Includes a small script to act as a client proxy for NetworkTables communication.
- **Safety Watchdog:** Ensures safe operation by monitoring and managing critical functions.

## Requirements

- **Apple Device:** iPad, Mac, or iPhone running iOS/macOS.
- **Swift:** The app is written in Swift, so you'll need to have Xcode installed for development and deployment.
- **NetworkTables:** The app relies on NetworkTables for robot communication.
- **Client Proxy Script:** A small script written in Python that facilitates NetworkTables communication.

## Build and Run
- Build the project and run it on your desired Apple device (iPad, Mac, or iPhone).

## Set Up Client Proxy
- Ensure the client proxy script is running and properly configured to handle NetworkTables communication.

## Usage
- **Connect to the Robot:** Launch HawkControl on your device and connect to your robot's NetworkTables server using the client proxy.
- **Monitor and Control:** Use the dashboard to monitor robot status, control robot functions, and receive real-time updates.
- **Safety Watchdog:** The built-in watchdog will ensure the safe operation of the robot by monitoring critical parameters and taking necessary actions if issues are detected.

## Set up on your robot
**Write later**
