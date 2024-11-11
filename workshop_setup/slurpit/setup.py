import os
import time
import requests
from requests_toolbelt.multipart.encoder import MultipartEncoder

# Suppress SSL warnings
requests.packages.urllib3.disable_warnings()

# -------------------------
# Step 0: Retrieve IP Address and Subnet from Environment Variables
# -------------------------

# Retrieve the IP address from the environment variable
my_external_ip = os.getenv('MY_EXTERNAL_IP')

# Retrieve the subnet for the workshop
workshop_subnet = os.getenv('WORKSHOP_SUBNET')

# Check if the environment variable is set
if not my_external_ip:
    print('Error: The environment variable MY_EXTERNAL_IP is not set.')
    exit(1)

# Check if the environment variable is set
if not workshop_subnet:
    print('Error: The environment variable WORKSHOP_SUBNET is not set.')
    exit(1)

# Base URL for the server
base_url = f'http://{my_external_ip}:8000'

# Create a session
session = requests.Session()

# -------------------------
# Wait for Service to Be Ready
# -------------------------

login_url = f'{base_url}/login'
timeout_seconds = 30
start_time = time.time()

while True:
    try:
        response = session.get(login_url, timeout=5)
        if response.status_code == 200:
            print("Service is available.")
            break
    except requests.exceptions.RequestException:
        pass  # Ignore connection errors and retry

    if time.time() - start_time > timeout_seconds:
        print(f"Error: Unable to connect to the service at {login_url} within {timeout_seconds} seconds.")
        exit(1)

    print("Waiting for the service to be ready...")
    time.sleep(1)

# -------------------------
# Step 1: Login to the Application
# -------------------------

# Login URL and headers
login_headers = {
    'Accept': 'application/json, text/javascript, */*; q=0.01',
    'Accept-Language': 'en-US,en;q=0.9',
    'Connection': 'keep-alive',
    'DNT': '1',
    'Origin': base_url,
    'Referer': f'{base_url}/',
    'User-Agent': 'Mozilla/5.0 (compatible; Python script)',
    'X-Requested-With': 'XMLHttpRequest',
}

# Login form data
login_data = {
    'invalidCredentials': '',
    'username': 'admin@admin.com',
    'password': '12345678',
}

# Prepare multipart/form-data
login_encoder = MultipartEncoder(fields=login_data)
login_headers['Content-Type'] = login_encoder.content_type

# Perform login
login_response = session.post(
    login_url,
    headers=login_headers,
    data=login_encoder,
    verify=False
)

# Check login success
if login_response.status_code == 200:
    print('Login successful.')
else:
    print('Login failed with status code:', login_response.status_code)
    print('Response:', login_response.text)
    exit(1)

# -------------------------
# Step 2: Make Authenticated Request
# -------------------------

# AddScanner URL and headers
add_scanner_url = f'{base_url}/DevicesFinder/addScanner'
add_scanner_headers = {
    'Accept': 'application/json, text/javascript, */*; q=0.01',
    'Accept-Language': 'en-US,en;q=0.9',
    'Connection': 'keep-alive',
    'DNT': '1',
    'Origin': base_url,
    'Referer': f'{base_url}/admin/devices_finder',
    'User-Agent': 'Mozilla/5.0 (compatible; Python script)',
    'X-Requested-With': 'XMLHttpRequest',
}

# AddScanner form data
add_scanner_data = {
    'name': 'autocon_workshop',
    'version': 'snmpv3',
    'snmpv2ckey': '',
    'snmpv3username': 'snmpuser',
    'snmpv3authtype': 'sha',
    'snmpv3authkey': 'snmppassword',
    'snmpv3privtype': 'aes128',
    'snmpv3privkey': 'snmpprivpassword',
    'content': workshop_subnet,  # Use the environment variable here as well
}

# Prepare multipart/form-data
add_scanner_encoder = MultipartEncoder(fields=add_scanner_data)
add_scanner_headers['Content-Type'] = add_scanner_encoder.content_type

# Perform the addScanner request
add_scanner_response = session.post(
    add_scanner_url,
    headers=add_scanner_headers,
    data=add_scanner_encoder,
    verify=False
)

# Check if the request was successful
if add_scanner_response.status_code == 200:
    print('addScanner request successful.')
    print('Response:', add_scanner_response.text)
else:
    print('addScanner request failed with status code:', add_scanner_response.status_code)
    print('Response:', add_scanner_response.text)