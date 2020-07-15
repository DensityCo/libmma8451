CC?=gcc
CFLAGS?=-fPIC
CFLAGS_SHARED?=-shared
OBJ=mma8451.o
LIBNAME=libmma8451.so
TESTOBJ=mma8451-test.o
TESTNAME=mma8451-test

all: compile

compile: $(LIBNAME) $(TESTNAME)

install: $(LIBNAME)
	install -d 0755 ${DESTDIR}/usr/lib $(DESTDIR)/usr/bin
	install -m 0644 $(LIBNAME) $(DESTDIR)/usr/lib/$(LIBNAME)
	install -m 0644 $(TESTNAME) $(DESTDIR)/usr/bin/$(TESTNAME)

fix-i2c:
	echo -n 1 > /sys/module/i2c_bcm2708/parameters/combined

clean:
	rm -f $(OBJ) $(TESTOBJ) $(LIBNAME) $(TESTNAME)

%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

$(LIBNAME): $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS) $(CFLAGS_SHARED)

$(TESTNAME): $(LIBNAME) $(TESTOBJ)
	$(CC) -o $@ $^ $(CFLAGS) -L. -lmma8451
