# myatzy
A version of Yatzy game
A Yatzy game originally written for Nokia N9.

## Building

Requires CMake 3.16+ and Qt 6 (Qt 5.15 should also work).

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
