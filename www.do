redo-ifchange *.texi VERSION
html=gogost.html
rm -f $html/*.html
${MAKEINFO:-makeinfo} --html \
    -D "VERSION `cat VERSION`" \
    --set-customization-variable EXTRA_HEAD='<link rev="made" href="mailto:webmaster@cypherpunks.ru">' \
    --set-customization-variable CSS_LINES="`cat style.css`" \
    --set-customization-variable SHOW_TITLE=0 \
    --set-customization-variable DATE_IN_HEADER=1 \
    --set-customization-variable TOP_NODE_UP_URL=index.html \
    --set-customization-variable CLOSE_QUOTE_SYMBOL=\" \
    --set-customization-variable OPEN_QUOTE_SYMBOL=\" \
    -o $html www.texi
find $html -type d -exec chmod 755 {} \;
find $html -type f -exec chmod 644 {} \;
