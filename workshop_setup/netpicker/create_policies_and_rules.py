import requests

# Server details
SERVER_URL = 'http://139.59.171.246:8003'

# Credentials
USERNAME = 'admin@admin.com'
PASSWORD = '12345678'

# Policy name
POLICY_NAME = 'autocon_workshop'

def get_token():
    auth_url = f'{SERVER_URL}/api/v1/auth/jwt/login'
    payload = {
        'grant_type': 'password',
        'scope': 'openid access:api',
        'username': USERNAME,
        'password': PASSWORD
    }
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded'
    }
    response = requests.post(auth_url, data=payload, headers=headers)
    response.raise_for_status()
    token = response.json().get('access_token')
    if not token:
        raise Exception('Authentication failed: No access_token found in response.')
    return token

def create_policy(token):
    api_url = f'{SERVER_URL}/api/v1/policy/default/'
    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {token}'
    }
    payload = {
        "name": POLICY_NAME,
        "description": "",
        "enabled": True,
        "id": POLICY_NAME
    }
    response = requests.post(api_url, headers=headers, json=payload)
    if response.status_code == 201:
        print(f"Policy '{POLICY_NAME}' created successfully.")
    elif response.status_code == 200:
        print(f"Policy '{POLICY_NAME}' already exists.")
    else:
        response.raise_for_status()
    return response.json()

def create_rule(token):
    api_url = f'{SERVER_URL}/api/v1/policy/default/{POLICY_NAME}/rule/'
    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {token}'
    }
    payload = {
        "name": "rule_check_hostname",
        "platform": ["nokia_srl"],
        "severity": "MEDIUM",
        "definition": {
            "code": """@medium(
    name='rule_check_hostname',
    platform=['nokia_srl'],
)
def rule_check_hostname(configuration, commands, device):
    assert f'host-name {device.name}' in configuration"""
        },
        "ruleset": POLICY_NAME
    }
    response = requests.post(api_url, headers=headers, json=payload)
    if response.status_code == 201:
        print("Rule 'rule_check_hostname' created successfully.")
    elif response.status_code == 200:
        print("Rule 'rule_check_hostname' already exists.")
    else:
        response.raise_for_status()
    return response.json()

def main():
    try:
        # Step 1: Authenticate and get a token
        token = get_token()
        print('Authentication successful.')

        # Step 2: Create the policy
        create_policy(token)

        # Step 3: Create the rule within the policy
        create_rule(token)

    except requests.HTTPError as e:
        print(f'HTTP Error: {e.response.status_code} - {e.response.text}')
    except Exception as e:
        print(f'An error occurred: {str(e)}')

if __name__ == '__main__':
    main()