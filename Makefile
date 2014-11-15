MAN_DIR     := man/man1

POD_FILES   := $(wildcard pod/*.pod)
HTML_FILES  := $(patsubst pod/%.pod,html/%.html, $(POD_FILES))
MAN_PAGES   := $(patsubst pod/%.pod,$(MAN_DIR)/%.1, $(POD_FILES))
MAN_BZ2     := $(addsuffix .bz2, $(MAN_PAGES))

DIRS       := html $(MAN_DIR)

P2M_OPTS   := --section 1
P2M_OPTS   += --center "antiX Documentation"
P2M_OPTS   += --date "$(shell date +%F)"
P2M_OPTS   += --release "Version 2.0.0"

P2H_OPTS   := --css $(CSS_FILE)
P2H_OPTS   += --title "$(TARGET) -- antiX Documentation"

TIDY_OPTS  := -q -file tidy-errors -i -wrap 100 -m

.PHONY: all html-files man-pages man-bz2 clean


all: $(HTML_FILES) man-pages

html-files: $(HTML_FILES)

$(HTML_FILES) : html/%.html : pod/%.pod
	bin/pod-simple $<  | bin/html-postfix > $@
	[ $@ != html/Boot_Options.html ] || bin/option-index -i $@
	@#tidy $(TIDY_OPTS) $@

#html/boot-options.html:  html/%.html : pod/%.pod
#	bin/pod-simple $<  | bin/html-postfix > $@

man-pages: $(MAN_PAGES)  

$(MAN_PAGES): $(MAN_DIR)/%.1 : pod/%.pod | $(MAN_DIR)
	pod2man $(P2M_OPTS) $< > $@

man-bz2: $(MAN_BZ2)

$(MAN_BZ2): %.bz2 : % | $(MAN_DIR)
	bzip2 --force $<

$(DIRS):
	mkdir -p $@

clean:
	rm -rf man/ html/*.html


