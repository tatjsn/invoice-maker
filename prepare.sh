if [ -n "$VIRTUAL_ENV" ]; then
    echo "You're running a Python virtual environment!"
else
    echo "You're not running a Python virtual environment."
    echo source .venv/bin/activate
    exit 1
fi

oauth2l fetch --credentials credential.json --scope gmail.readonly --refresh

make clean

echo "Ready!"
