DESTDIR=./
SETUPDIR=$(DESTDIR)usr/share
DESKTOPEXEC=/usr/share
TARGET=aif
LABEL_NAME=$(TARGET)-master
LABEL_DESKTOP=$(LABEL_NAME).desktop
GITURL="https://github.com/maximalisimus/$(LABEL_NAME).git"
EXEC=$(DESKTOPEXEC)/$(LABEL_NAME)/$(TARGET)
SETUPEXEC=$(DESTDIR)usr/bin/$(LABEL_NAME)
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
	for i in $(icon_sizes) ; do \
		mkdir -p $(ICONDIR)/hicolor/$$i/apps/ ; \
		convert $(ICONFL) -resize $$i $(ICONDIR)/hicolor/$$i/apps/$(ICON_NAME).png ; \
	done
desktop:
	touch $(LABEL_DESKTOP)
	echo "[Desktop Entry]" > $(LABEL_DESKTOP)
	echo "Exec=sudo $(DESKTOPEXEC)/$(LABEL_NAME)/$(TARGET)" >> $(LABEL_DESKTOP)
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
	mkdir -p $(SETUPDIR)/$(LABEL_NAME) $(SETUPDIR)/icons/hicolor/ $(SETUPDIR)/applications/ $(DESTDIR)usr/bin/
	cp -a $(SOURCES)/* $(SETUPDIR)/$(LABEL_NAME)/
	find ./ -type f -iname "$(LABEL_DESKTOP)" -exec cp -f {} $(SETUPDIR)/applications/ \;
	cp -a $(ICONDIR)/hicolor/* $(SETUPDIR)/icons/hicolor/
	find "$(SETUPDIR)/applications/" -type f -iname "$(LABEL_DESKTOP)" -exec chmod +x {} \;
	find "$(SETUPDIR)/$(LABEL_NAME)/" -type f -iname "$(TARGET)" -exec chmod +x {} \;
	ln -s $(EXEC) $(SETUPEXEC)
	find "$(DESTDIR)usr/bin/" -type f -iname "$(LABEL_NAME)" -exec chmod +x {} \;
uninstall: clean
	find $(SETUPDIR)/applications/ -type f -iname "$(LABEL_DESKTOP)" -exec rm -rf {} \;
	rm -rf $(SETUPDIR)/$(LABEL_NAME)/
	find $(SETUPDIR)/icons/hicolor/ -type f -iname "$(ICON_NAME).png" -exec rm -rf {} \;
	rm -rf $(SETUPEXEC)
clean:
	rm -rf $(ICONDIR)/hicolor/
	find ./ -type f -iname "$(LABEL_DESKTOP)" -exec rm -rf {} \;
