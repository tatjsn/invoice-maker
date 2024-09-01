TOKEN := $(shell oauth2l fetch --credentials credential.json --scope gmail.readonly --refresh)

electric.pdf:
	python attachment.py $(TOKEN) "from:ebill@mea.or.th newer_than:30d subject:ใบแจ้ง" $@

water.pdf:
	python attachment.py $(TOKEN) "from:no-reply@mwa.co.th newer_than:30d subject:ใบแจ้ง" $@

%.png: %.pdf
	pdftoppm -png -singlefile $< $(basename $@)

%.amount.txt: %.png
	python amount.py $< $@

all: electric.amount.txt water.amount.txt electric.png water.png
	python report.py $^

clean:
	rm -f electric.* water.*
