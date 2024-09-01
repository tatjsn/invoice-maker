ENDPOINT := "https://gmail.googleapis.com/gmail/v1/users/me/messages"
HEADER := $(shell oauth2l header --credentials credential.json --scope gmail.readonly)
CURL := curl --get -s -H "$(HEADER)"

message_id = $(shell jq -r .messages[0].id $(1))
attachment_id = $(shell gron $(1) | \
	grep attachment | \
	fgrep '.pdf' | \
	perl -pe 's/^json(\.payload\.parts\[\d\].*?)\.headers.*/$$1/'| \
	xargs -I '{}' jq -r {}.body.attachmentId $(1))

electric.message-list.json:
	$(CURL) --data-urlencode "q=from:ebill@mea.or.th newer_than:30d subject:ใบแจ้ง" "$(ENDPOINT)" -o $@

water.message-list.json:
	$(CURL) --data-urlencode "q=from:no-reply@mwa.co.th newer_than:30d subject:ใบแจ้ง" "$(ENDPOINT)" -o $@

%.message.json: %.message-list.json
	$(CURL) "$(ENDPOINT)/$(call message_id,$<)" -o $@

%.attachment.json: %.message.json %.message-list.json
	$(CURL) "$(ENDPOINT)/$(call message_id,$(word 2,$^))/attachments/$(call attachment_id,$<)" -o $@

%.pdf: %.attachment.json
	python attachment.py $< $@

%.png: %.pdf
	pdftoppm -png -singlefile $< $(basename $@)

%.amount.txt: %.png
	python amount.py $< $@

all: electric.amount.txt water.amount.txt electric.png water.png
	python report.py $^

clean:
	rm -f electric.* water.*
