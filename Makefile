util_runobjs := $(patsubst utilities/%.s,utilities/%_r.o,$(wildcard utilities/*.s))
util_debugobjs := $(patsubst utilities/%.s,utilities/%_d.o,$(wildcard utilities/*.s))
day_runobjs := $(patsubst %.s,%_r.o,$(wildcard src/*.s))
day_debugobjs := $(patsubst %.s,%_d.o,$(wildcard src/*.s))
day_targets := $(patsubst src/%.s,%,$(wildcard src/*.s))
debug_targets := $(patsubst src/%.s,%_d,$(wildcard src/*.s))

all: $(day_targets)

debug: $(debug_targets)

$(util_runobjs) : utilities/%_r.o : utilities/%.s
	as $^ -o $@

$(util_debugobjs) : utilities/%_d.o : utilities/%.s
	as --gstabs+ $^ -o $@

$(day_runobjs) : src/%_r.o : src/%.s
	as $^ -o $@

$(day_debugobjs) : src/%_d.o : src/%.s
	as --gstabs+ $^ -o $@

$(debug_targets) : %_d : src/%_d.o $(util_debugobjs)
	ld $^ -o $@

$(day_targets) : % : src/%_r.o $(util_runobjs)
	ld $^ -o $@

clean:
	rm -f src/*.o
	rm -f src/*.ro
	rm -f utilities/*.o
	rm -f utilities/*.ro
	rm -f *.a
	rm -f *.o
	rm -f *.ro
