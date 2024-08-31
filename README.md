# Invoice Maker

## Requirements

- ImageMagick
- oauth2l
- jq
- gron
- python

## How to setup

```sh
python -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

## Credentials

- `credential.json`: Google API
- `firebase-adminsdk.json`: Firebase Admin SDK
- `line.json`: LINE `token` and `userId`
- `gemini.json`: Gemini `apiKey`


## How to use

1. Put `credential.json` to the working directory.
2. Run the following command:

```sh
sh prepare.sh
make all
```

## FAQs

### How to fix ImageMagick 'not authorized' error

In `/etc/ImageMagick-6/policy.xml`:

```diff
--- <policy domain="coder" rights="none" pattern="PDF" />
+++ <policy domain="coder" rights="read|write" pattern="PDF" />
```
