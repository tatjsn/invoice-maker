if [ -n $(which python) ]; then
    echo "Missing python alias e.g. alias python=/usr/bin/python3"
    exit 1
fi

if [ -n "$VIRTUAL_ENV" ]; then
    echo "You're running a Python virtual environment!"
else
    echo "You're not running a Python virtual environment."
    echo source .venv/bin/activate
    exit 1
fi

oauth2l header --credentials credential.json --scope gmail.readonly

make clean

echo "Ready!"
