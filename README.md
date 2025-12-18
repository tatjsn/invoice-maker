# Invoice Maker

## Requirements

- oauth2l
- python
- pdftoppm

## How to setup

```bash
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

1. Put credentials to the working directory.
2. Run the following command:

```bash
./deploy
```
