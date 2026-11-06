# myatzy
A version of Yatzy game
A Yatzy game originally written for Nokia N9.

## Controls

Click the dice to hold them and a row of the score card to score it, or
use the keyboard:

| Key | Action |
| --- | --- |
| Space | Roll (or start a new game when the game is over) |
| 1-5 | Hold or release a die |
| Arrow keys | Choose a hand on the score card |
| Enter | Score the chosen hand |
| M, F1 | Menu |

## Building

Requires CMake 3.21+ and Qt 6.5 or newer.

```sh
cmake -S . -B build
cmake --build build
./build/myatzy
```

## Running the tests

```sh
ctest --test-dir build --output-on-failure
```

Pass `-DBUILD_TESTING=OFF` to `cmake` to skip building the tests.
