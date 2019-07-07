util_objs := $(patsubst %.s,%.o,$(wildcard utilities/*.s))
day_objs := $(patsubst %.s,%.o,$(wildcard src/*.s))
day_targets := $(patsubst src/%.s,%,$(wildcard src/*.s))

all: $(day_targets)

utilities/*.o: utilities/*.s
	as $^ -o $@

src/*.o: src/*.s
	as $^ -o $@

$(day_targets): %: src/%.o $(util_objs)
	ld $^ -o $@

clean:
	rm -f src/*.o
	rm -f utilities/*.o
	rm -f *.a
	rm -f *.o
