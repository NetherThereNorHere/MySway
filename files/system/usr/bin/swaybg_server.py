#!/usr/bin/env python3
from http.server import BaseHTTPRequestHandler, HTTPServer
import subprocess
import os
import sys

# SECURITY: Reads the password from your local system environment variable.
# If the variable isn't set, it drops back to a default fallback string.
AUTH_TOKEN = os.getenv("SWAYBG_AUTH_TOKEN", "fallback_local_secret_code_999")

green_process = None

class BackgroundHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        global green_process
        
        # 1. SECURITY HEADER CHECK
        client_token = self.headers.get('X-Swaybg-Token')
        if client_token != AUTH_TOKEN:
            self.send_response(403)  # HTTP 403 Forbidden
            self.end_headers()
            return

        self.send_response(200)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Headers", "X-Swaybg-Token")
        self.end_headers()
        
        # 2. STACKING OVERLAY LOGIC
        if self.path == '/focus':
            # Only spawn a new green layer if one isn't already active
            if green_process is None:
                green_process = subprocess.Popen(["swaybg", "-c", "#00FF00", "-m", "solid_color"])
            
        elif self.path == '/blur':
            if green_process is not None:
                # Terminate only the top green layer, instantly revealing the wallpaper
                green_process.terminate()
                green_process.wait()  # Clean up process memory cleanly
                green_process = None

    def log_message(self, format, *args):
        return  # Suppress internal python terminal server logging

if __name__ == '__main__':
    server = HTTPServer(('localhost', 8080), BackgroundHandler)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        if green_process is not None:
            green_process.terminate()
        sys.exit(0)
