BINDIR			=	/usr/bin


all: install

install:
	install -d -m 0755 deDOS.sh $(BINDIR)/dedos

uninstall:
	rm $(BINDIR)/dedos

