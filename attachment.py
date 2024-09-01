from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build
import sys
import base64


def find_pdf_part(parts):
    for part in parts:
        if 'parts' in part:
            result = find_pdf_part(part['parts'])  # Recursively search in sub-parts
            if result:
                return result
        elif part.get('filename', '').endswith('.pdf'):
            return part
    return None

def download_attachment(token, query):
    creds = Credentials(token)
    service = build("gmail", "v1", credentials=creds)
    results = service.users().messages().list(userId="me", q=query).execute()
    message_id = results.get("messages", [])[0].get("id")
    message = service.users().messages().get(userId="me", id=message_id).execute()
    part = find_pdf_part(message.get('payload').get('parts', []))
    if part:
        attachment_id = part['body'].get('attachmentId')
        if attachment_id:
            attachment = service.users().messages().attachments().get(
                userId="me", messageId=message_id, id=attachment_id).execute()
            return base64.urlsafe_b64decode(attachment['data'].encode('UTF-8'))
    return None

if __name__ == '__main__':
    attachment = download_attachment(sys.argv[1], sys.argv[2])

    with open(sys.argv[3], "wb") as f:
        f.write(attachment)
