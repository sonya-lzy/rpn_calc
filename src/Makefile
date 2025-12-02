CC = g++
CFLAGS = -std=c++11 -Wall -Wextra
TARGET = rpn_calc
SRC = rpn_calc.cpp

all: $(TARGET)

$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRC)

clean:
	rm -f $(TARGET)

run: $(TARGET)
	./$(TARGET)

.PHONY: all clean run
