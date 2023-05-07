from decimal import Decimal
from datetime import datetime
import json
import sys
from linebot import LineBotApi
from linebot.models import TextSendMessage, ImageSendMessage
import upload

def to_decimal(scanned_number):
    return Decimal(scanned_number.strip().replace(',', ''))

def report(electricity_string, water_string):
    electricity = to_decimal(electricity_string)
    water = to_decimal(water_string)

    # Workaround if the decimal wasn't recognisable
    if water > 1000:
        water /= 100

    telephone = 107
    rent = 6000

    total = electricity + water + telephone + rent

    date = datetime.now().strftime("15/%m/%y")

    return f"""ขอแจ้งบิลรอบ {date}

ไฟฟ้า+น้ำ+โทร+บ้าน={electricity}+{water}+{telephone}+{rent}={total}บาท
โอนเสร็จโปรดแจ้งกลับด้วย ขอบคุณครับ"""

def push(message, line_config):
    line_bot_api = LineBotApi(line_config["token"])
    line_bot_api.push_message(line_config["userId"], TextSendMessage(text=message))

def push_image(source_file_name, prefix, line_config):
    date = datetime.now().strftime("15-%m-%y")
    url = upload.upload(source_file_name, f"{prefix}-{date}.png")
    line_bot_api = LineBotApi(line_config["token"])
    line_bot_api.push_message(line_config["userId"], ImageSendMessage(original_content_url=url, preview_image_url=url))

if __name__ == '__main__':
    with open(sys.argv[1], "r") as f:
        electricity_string = f.read()

    with open(sys.argv[2], "r") as f:
        water_string = f.read()

    with open("line.json", "r") as f:
        line_config = json.loads(f.read())

    report_string = report(electricity_string, water_string)
    push(report_string, line_config)

    upload.init()
    push_image(sys.argv[3], "electricity", line_config)
    push_image(sys.argv[4], "water", line_config)
