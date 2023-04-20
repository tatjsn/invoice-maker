electric.pdf:
	cp $$(ls -t ~/Downloads/ELE_*.pdf | head -1) $@

water.pdf:
	cp $$(ls -t ~/Downloads/W*.pdf | head -1) $@

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
