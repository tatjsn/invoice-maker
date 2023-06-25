import sys
import json
import base64

def extract_attachment(payload):
    return base64.urlsafe_b64decode(payload['data'])

if __name__ == '__main__':
    with open(sys.argv[1], "r") as f:
        payload = json.load(f)

    attachment = extract_attachment(payload)

    with open(sys.argv[2], "wb") as f:
        f.write(attachment)
