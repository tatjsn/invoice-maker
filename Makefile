ENDPOINT := "https://gmail.googleapis.com/gmail/v1/users/me/messages"
HEADER := $(shell oauth2l header --credentials credential.json --scope gmail.readonly --refresh)
CURL := curl --get -s -H "$(HEADER)"

message_id = $(shell jq -r .messages[0].id $(1))
attachment_id = $(shell gron $(1) | \
	grep attachment | \
	fgrep '.pdf' | \
	perl -pe 's/^json(\.payload\.parts\[\d\].*?)\.headers.*/$$1/'| \
	xargs -I '{}' jq -r {}.body.attachmentId $(1))

electric.message-list.json:
	$(CURL) --data-urlencode "q=from:ebill@mea.or.th newer_than:30d ใบแจ้ง" "$(ENDPOINT)" -o $@

water.message-list.json:
	$(CURL) --data-urlencode "q=from:mwatax@mwa.co.th newer_than:30d ใบแจ้ง" "$(ENDPOINT)" -o $@

%.message.json: %.message-list.json
	$(CURL) "$(ENDPOINT)/$(call message_id,$<)" -o $@

%.attachment.json: %.message.json %.message-list.json
	$(CURL) "$(ENDPOINT)/$(call message_id,$(word 2,$^))/attachments/$(call attachment_id,$<)" -o $@

%.pdf: %.attachment.json
	jq -r .data $< | base64 --decode -o $@

%.raw.png: %.pdf
	convert -density 300 $<[0] $@

%.flat.png: %.raw.png
	convert $< -background white -flatten -alpha off $@

electric.crop.png: electric.flat.png
	convert $< -crop 830x90+160+1300 $@

water.crop.png: water.flat.png
	convert $< -crop 150x60+900+735 $@

%.ocr.txt: %.crop.png
	tesseract -l tha+eng --psm 7 $< stdout > $@

%.amount.txt: %.ocr.txt
	cat $< | perl -pe 's/.*?([0-9,.]+).*/$$1/' > $@

all: electric.amount.txt water.amount.txt
	./report $^

clean:
	rm electric.* water.*
