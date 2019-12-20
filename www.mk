MAKEINFO ?= makeinfo

CSS != cat style.css

all: gogost.html

gogost.html: *.texi
	rm -f gogost.html/*.html
	$(MAKEINFO) --html \
		--set-customization-variable EXTRA_HEAD='<link rev="made" href="mailto:webmaster@cypherpunks.ru">' \
		--set-customization-variable CSS_LINES='$(CSS)' \
		--set-customization-variable SHOW_TITLE=0 \
		--set-customization-variable USE_ACCESSKEY=0 \
		--set-customization-variable DATE_IN_HEADER=1 \
		--set-customization-variable TOP_NODE_UP_URL=index.html \
		--set-customization-variable CLOSE_QUOTE_SYMBOL=\" \
		--set-customization-variable OPEN_QUOTE_SYMBOL=\" \
		-o gogost.html www.texi
