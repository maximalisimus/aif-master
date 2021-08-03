DESTDIR=./
SETUPDIR=$(DESTDIR)usr/share
TARGET=aif
LABEL_NAME=$(TARGET)-master
LABEL_DESKTOP=$(LABEL_NAME).desktop
GITURL="https://github.com/maximalisimus/$(LABEL_NAME).git"
SOURCES=$(TARGET)-installation
ICONDIR=icons
IMAGEDIR=image
ICON_NAME=$(TARGET)-icon
ICONFL=$(ICONDIR)/$(ICON_NAME).png
#
DESCENG="Installing the ArchLinux system in pseudographic mode using the dialog package."
DESCRU="Установка системы ArchLinux в псевдографическом режиме, используя пакет dialog."
#
sizes:=16 24 32 64 96 128
icon_sizes:=$(foreach sz,$(sizes),$(sz)x$(sz))
#
.PHONY: all icon desktop install uninstall clean
all: icon desktop
	echo ""
	echo "Please enter to: make install"
	echo ""
icon:
ifeq ($(shell test -e $(ICONFL) && echo -n yes || echo -n no),yes)
	for i in $(icon_sizes) ; do \
		mkdir -p $(ICONDIR)/hicolor/$$i/apps/ ; \
		convert $(ICONFL) -resize $$i $(ICONDIR)/hicolor/$$i/apps/$(ICON_NAME).png ; \
	done
endif
desktop:
	touch $(LABEL_DESKTOP)
	echo "[Desktop Entry]" > $(LABEL_DESKTOP)
	echo "Exec=sudo $(SETUPDIR)/$(LABEL_NAME)/$(TARGET)" >> $(LABEL_DESKTOP)
	echo "Type=Application" >> $(LABEL_DESKTOP)
	echo "Name=$(LABEL_NAME)" >> $(LABEL_DESKTOP)
	echo "Name[en]=$(LABEL_NAME)" >> $(LABEL_DESKTOP)
	echo "Name[ru]=$(LABEL_NAME)" >> $(LABEL_DESKTOP)
	echo "Terminal=true" >> $(LABEL_DESKTOP)
	echo "Icon=$(ICON_NAME)" >> $(LABEL_DESKTOP)
	echo "Categories=GNOME;GTK;Utility;" >> $(LABEL_DESKTOP)
	echo "X-GNOME-UsesNotifications=true" >> $(LABEL_DESKTOP)
	echo "Comment=$(DESCENG)" >> $(LABEL_DESKTOP)
	echo "Comment[en]=$(DESCENG)" >> $(LABEL_DESKTOP)
	echo "Comment[ru]=$(DESCRU)" >> $(LABEL_DESKTOP)
	find ./ -type f -iname "$(LABEL_DESKTOP)" -exec chmod ugo+x {} \;
install:
	rm -rf $(SETUPDIR)/$(LABEL_NAME)
	mkdir -p $(SETUPDIR)/$(LABEL_NAME) $(SETUPDIR)/icons/hicolor/ $(SETUPDIR)/applications/
ifeq ($(shell test -e $(SOURCES) && echo -n yes || echo -n no),yes)
	cp -a $(SOURCES)/* $(SETUPDIR)/$(LABEL_NAME)/
	find ./ -type f -iname "$(LABEL_DESKTOP)" -exec cp -f {} $(SETUPDIR)/applications/ \;
	ifeq ($(shell test -e $(ICONDIR) && echo -n yes || echo -n no),yes)
		cp -a $(ICONDIR)/hicolor/* $(SETUPDIR)/icons/hicolor/
	endif
	find "$(SETUPDIR)/applications/" -type f -iname "$(LABEL_DESKTOP)" -exec chmod +x {} \;
	find "$(SETUPDIR)/$(LABEL_NAME)/" -type f -iname "$(TARGET)" -exec chmod +x {} \;
endif
uninstall: clean
	find $(SETUPDIR)/applications/ -type f -iname "$(LABEL_DESKTOP)" -exec rm -rf {} \;
	rm -rf $(SETUPDIR)/$(LABEL_NAME)/
	find $(SETUPDIR)/icons/hicolor/ -type f -iname "$(ICON_NAME).png" -exec rm -rf {} \;
clean:
	rm -rf $(ICONDIR)/hicolor/
	find ./ -type f -iname "$(LABEL_DESKTOP)" -exec rm -rf {} \;
