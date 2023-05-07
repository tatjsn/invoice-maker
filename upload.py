import firebase_admin
from firebase_admin import credentials
from firebase_admin import storage
import json
from uuid import uuid4
import datetime
import sys

def init():
    with open('./firebase-adminsdk.json') as f:
        project_id = json.load(f)['project_id']

    cred = credentials.Certificate('./firebase-adminsdk.json');

    firebase_admin.initialize_app(cred, {
        'storageBucket': f'{project_id}.appspot.com'
    })


def upload(source_file_name, destination_blob_name):
    bucket = storage.bucket()

    blob = bucket.blob(destination_blob_name)

    blob.upload_from_filename(source_file_name)

    blob = bucket.get_blob(destination_blob_name)

    token = str(uuid4())
    blob.metadata = {'firebaseStorageDownloadTokens': token}
    blob.patch()

    return f"https://firebasestorage.googleapis.com/v0{blob.path}?alt=media&token={token}"


if __name__ == '__main__':
    init()
    url = upload(sys.argv[1], sys.argv[2])
    print(url)
