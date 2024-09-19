#!/usr/bin/env python

import threading
import ntcore as nt4
import websockets
import socket
import asyncio
import json
import logging
import time

# Configure logging
logging.basicConfig(level=logging.INFO)

# Initialize NetworkTables
inst = nt4.NetworkTableInstance.getDefault()
inst.startClient4("PyProxy")
inst.setServer("10.26.1.2")
# inst.setServer("0.0.0.0 ")

# limelight-arm_Stream
# limelight-shooter_Stream

# Tables
controls = inst.getTable("controls")
status = inst.getTable("status")

# Heartbeat settings
HEARTBEAT_INTERVAL = 5
WATCHDOG_TIMEOUT = 15
UPDATE_INTERVAL = .15
last_activity_time = time.time()

ALLOWED_KEYS = ['podiumShot', 'subwooferShot', 'noteToAmp', 'intakeFromHuman', 'manualIntake', 'reverseIntake', 'elevatorHome']

note_status = status.getStringTopic("noteStatus").subscribe('NOTHING')
robot_state = status.getStringTopic("robotState").subscribe('DISABLED')
is_ready_to_shoot = status.getBooleanTopic("isReadyToShoot").subscribe(False)
elevator_level = status.getStringTopic("elevatorLevel").subscribe('Home')
alliance = status.getStringTopic("alliance").subscribe('None')

arm_stream = inst.getTable("SmartDashboard").getStringTopic("limelight-arm_Stream").subscribe("")
shooter_stream = inst.getTable("SmartDashboard").getStringTopic("limelight-shooter_Stream").subscribe("")

def broadcast_listener():
    broadcast_ip = "0.0.0.0"  # Bind to all network interfaces
    broadcast_port = 2602   # Port for broadcasting

    server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server_socket.bind((broadcast_ip, broadcast_port))

    while True:
        message, client_address = server_socket.recvfrom(1024)
        if message.decode() == "DISCOVER":
            server_ip = socket.gethostbyname(socket.gethostname())
            server_socket.sendto(server_ip.encode(), client_address)
            print(f"Responded to discovery request from {client_address}")


def str_to_bool(val):
    if val == "true" or val == "True" or val == True:
        return True
    else:
        return False
    
async def send_to_robot(key, value, table):
    if (value.__class__ == bool):
        inst.getTable(table).putBoolean(key, str_to_bool(value))
    
async def reset_all_values():
    async for item in ALLOWED_KEYS:
        controls.putBoolean(item, False)
        
async def send_to_client(websocket):
    while True:
        update_data = {
            "noteStatus": note_status.get(),
            "robotState": robot_state.get(),
            "isReadyToShoot": "Yes" if is_ready_to_shoot.get() == True else "No",
            "ampStreamURL": arm_stream.get(),
            "shooterStreamURL": shooter_stream.get(),
            "elevatorLevel": elevator_level.get(),
            "alliance": alliance.get()
        }
        
        await websocket.send(json.dumps(update_data))
        await asyncio.sleep(UPDATE_INTERVAL)

async def handler(websocket, path):
    logging.info("Connected to WebSocket")
    global last_activity_time
    try:
        async def send_heartbeat():
            while True:
                await websocket.send(json.dumps({"heartbeat": True}))
                await asyncio.sleep(HEARTBEAT_INTERVAL)

        heartbeat_task = asyncio.create_task(send_heartbeat())
        update_task = asyncio.create_task(send_to_client(websocket))

        async for message in websocket:
            logging.info(f"Received: {message}")
            data = json.loads(message)
            
            if "heartbeat" in data:
                # reset watchdog timer
                logging.info("Received heartbeat")
                last_activity_time = time.time()
                continue  # skip processing further if it's a heartbeat

            # normal commands
            for key, value in data.items():
                if key in ALLOWED_KEYS:
                    controls.putBoolean(key, str_to_bool(value))
                    # send_to_robot(key, value, "controls")
                    await websocket.send(f"Updated {key} to {value}")
                    last_activity_time = time.time()  # Update last activity time
                else:
                    logging.warning(f"Unsupported key: {key}")
            # reset watchdog timer on every valid message received
            last_activity_time = time.time()

        heartbeat_task.cancel()  # cancel heartbeat && update_task when connection closes
        update_task.cancel()
    except websockets.ConnectionClosed as e:
        logging.info(f"Connection closed: {e}")
    except Exception as e:
        logging.error(f"Error: {e}")

async def watchdog():
    global last_activity_time
    while True:
        current_time = time.time()
        elapsed_time = current_time - last_activity_time
        if elapsed_time > WATCHDOG_TIMEOUT:
            # put what to do when watchdog is triggered
            logging.warning(f"Watchdog timeout: No activity for {elapsed_time} seconds")
            for key in ALLOWED_KEYS:
                controls.putBoolean(key, False)
            
        await asyncio.sleep(1)

async def main():    
    try:
        logging.info("Starting WebSocket server on 0.0.0.0:2601")
        server = await websockets.serve(handler, "0.0.0.0", 2601)
        watchdog_task = asyncio.create_task(watchdog()) # on separate thread
        async with server:
            await asyncio.gather(watchdog_task)
    except Exception as e:
        logging.error(f"Failed to start WebSocket server: {e}")

if __name__ == "__main__":
    try:
        broadcast_thread = threading.Thread(target=broadcast_listener, daemon=True)
        broadcast_thread.start()
        asyncio.run(main())
    except Exception as e:
        logging.error(f"Error in main: {e}")
