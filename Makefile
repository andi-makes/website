SOURCES = index
RESOURCES = img/avatar.svg style.css favicon.png source-serif-text.css source-serif-display.css source-serif-smtext.css fonts/SourceSerif4-Bold.otf.woff2 fonts/SourceSerif4-BoldIt.otf.woff2 fonts/SourceSerif4-It.otf.woff2 fonts/SourceSerif4-Regular.otf.woff2 fonts/SourceSerif4Display-Bold.otf.woff2 fonts/SourceSerif4SmText-Regular.otf.woff2
SERVER_DIR = /var/www/andi-makes.dev


OBJECTS = $(patsubst %, output/%.html, $(SOURCES)) $(patsubst %, output/%, $(RESOURCES))

TEMPLATE = template.html

compile: $(OBJECTS)

output/%.html: src/%.md $(TEMPLATE)
	mkdir -p $(@D)
	pandoc -s --wrap=preserve --template=$(TEMPLATE) --css=style.css $< -o $@

output/%: resources/%
	mkdir -p $(@D)
	cp -Ru $< $@
	
upload: compile
	tar -cz -C output . | ssh root@schmarrnfee.schmarrn.dev "rm -rf $(SERVER_DIR) && mkdir $(SERVER_DIR) && tar -xzv -C $(SERVER_DIR) --no-same-permissions"

clean:
	rm -r output
