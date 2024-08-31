import google.generativeai as genai
import PIL.Image
import json
import sys
import re

def extract_amount(filename):
    model = genai.GenerativeModel("gemini-1.5-flash")
    organ = PIL.Image.open(filename)
    response = model.generate_content(["What is the total amount of this invoice?", organ])
    return re.search(r"[\d,]+\.\d+", response.text).group()

if __name__ == '__main__':
    with open("gemini.json", "r") as f:
        gemini_config = json.loads(f.read())

    genai.configure(api_key=gemini_config["apiKey"])

    amount = extract_amount(sys.argv[1])

    with open(sys.argv[2], "w") as f:
        f.write(amount)
