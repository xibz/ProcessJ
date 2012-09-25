BIN := iris
INCLUDE_DIR := ./includes/
LIB_DIR :=
LIBS :=
AST_DIR := ./AST/
CXX_SRCS := $(wildcard *.cpp)
CXX_OBJS := ${CXX_SRCS:.cpp=.o}
BIN_OBJS := $(CXX_OBJS)

CPPFLAGS += $(foreach iDir, $(INCLUDE_DIR), -I $(iDir))
CPPFLAGS += $(foreach file, $(AST_DIR), $(file))
LDFLAGS += $(foreach lDir, $(LIBS), -L $(lDir))
LDFLAGS += $(foreach lib, $(LIB_DIR), -l $(lib))

.PHONY: all clean distclean

all: $(BIN)

$(BIN): $(BIN_OBJS)
	$(LINK.cc) $(BIN_OBJS) -o $(BIN)

clean:
	@- $(RM) $(BIN)
	@- $(RM) $(BIN_OBJS)

distclean: clean
