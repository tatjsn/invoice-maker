HEADER = $(shell oauth2l header --credentials credential.json --scope gmail.readonly)

electric.message-list.json:
	curl --get -H "$(HEADER)" --data-urlencode "q=from:ebill@mea.or.th ใบแจ้ง" "https://gmail.googleapis.com/gmail/v1/users/me/messages" -o $@

water.message-list.json:
	curl --get -H "$(HEADER)" --data-urlencode "q=from:mwatax@mwa.co.th ใบแจ้ง" "https://gmail.googleapis.com/gmail/v1/users/me/messages" -o $@

%.message.json: %.message-list.json
	curl --get -H "$(HEADER)" "https://gmail.googleapis.com/gmail/v1/users/me/messages/$$(jq -r .messages[0].id $<)" -o $@

%.attachment.json: %.message.json %.message-list.json
	$(eval ATTACHMENT := $(shell gron $< | grep attachment | fgrep '.pdf' | perl -pe 's/^json(\.payload\.parts\[\d\].*?)\.headers.*/$$1/'| xargs -I '{}' jq -r {}.body.attachmentId $<))
	curl --get -H "$(HEADER)" "https://gmail.googleapis.com/gmail/v1/users/me/messages/$$(jq -r .messages[0].id $(word 2,$^))/attachments/$(ATTACHMENT)" -o $@

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
