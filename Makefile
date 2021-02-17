
MMARK := ./mmark

%.xml: %.md
	cat $< | $(MMARK) -2 > $@

.PHONY: build

xml: draft-ietf-jmap-jscontact.xml

distclean:
	rm -f draft-ietf-jmap-jscontact.xml
