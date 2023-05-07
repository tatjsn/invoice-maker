if [ -n "$VIRTUAL_ENV" ]; then
    echo "You're running a Python virtual environment!"
else
    echo "You're not running a Python virtual environment."
    source .venv/bin/activate
fi

oauth2l header --credentials credential.json --scope gmail.readonly

echo "Ready!"
