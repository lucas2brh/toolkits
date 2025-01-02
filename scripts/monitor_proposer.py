import websocket
import json

# WebSocket URL
WS_URL = "ws://localhost:8546"

# Subscription request
REQUEST_DATA = {
    "jsonrpc": "2.0",
    "method": "eth_subscribe",
    "params": ["newHeads"],
    "id": 1
}

# Target proposer address
TARGET_PROPOSER = "0xdb8E606AD7c02F37E43D10A10126791DC94b0434"

def on_message(ws, message):
    try:
        data = json.loads(message)
        
        # Check if the message contains a miner address
        if "params" in data and "result" in data["params"] and "miner" in data["params"]["result"]:
            miner = data["params"]["result"]["miner"]

            # Check if the miner matches the target proposer
            if miner.lower() == TARGET_PROPOSER.lower():
                print("\n" + "="*50)
                print("🎯 Target proposer found!")
                print("Proposer Address (Miner):", miner)
                print("Full Block Data:\n", json.dumps(data, indent=4))
                print("="*50 + "\n")
            else:
                print(f"Block received. Miner: {miner}")

    except Exception as e:
        print(f"Error processing message: {e}")

def on_error(ws, error):
    print(f"WebSocket error: {error}")

def on_close(ws, close_status_code, close_msg):
    print("WebSocket connection closed")

def on_open(ws):
    print("Connected to WebSocket, subscribing to newHeads...")
    ws.send(json.dumps(REQUEST_DATA))

if __name__ == "__main__":
    websocket.enableTrace(False)
    ws = websocket.WebSocketApp(WS_URL,
                                on_open=on_open,
                                on_message=on_message,
                                on_error=on_error,
                                on_close=on_close)
    ws.run_forever()