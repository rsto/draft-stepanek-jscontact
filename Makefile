
MMARK := mmark

%.xml: %.md
	cat $< | $(MMARK) -2 > $@

.PHONY: build

xml: draft-ietf-calext-jscontact.xml

distclean:
	rm -f draft-ietf-calext-jscontact.xml
