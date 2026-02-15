#!/bin/bash

WINDOWS=false
WIN_FLAGS=""

RUN=false

INPUT="$(find src -name '*.c')"
OUTPUT="a"
RAYLIB="$HOME/raylib"

# parse arguments
while [ $# -gt 0 ]; do
    case $1 in
        -noconsole)
            WIN_FLAGS="$WIN_FLAGS -mwindows"
            shift
            ;;
        -win32)
            WINDOWS=true
            shift
            ;;
        -run)
            RUN=true
            shift
            ;;
        -o)
            if [ -n "$2" ]; then
                OUTPUT="$2"
                shift 2
            else
                echo "Error: -o requires a filename"
                exit 1
            fi
            ;;
        -raylib)
            if [ -n "$2" ]; then
                RAYLIB="$2"
                shift 2
            else
                echo "Error: -raylib requires a path to raylib"
                exit 1
            fi
            ;;
        *)
            echo "Unknown option: $1"
            shift
            ;;
    esac
done

#################################################

BUILD_DIR="build/"
RES="res/"

# create build folder
mkdir -p "$BUILD_DIR"

# copy resources
if [ "$WINDOWS" = true ]; then
    BUILD_DIR="$BUILD_DIR/win32/"
else
    BUILD_DIR="$BUILD_DIR/bin/"
fi

DEST="$BUILD_DIR/$RES"

mkdir -p "$DEST"
rsync -a --delete "$RES" "$DEST"

#################################################

if [ "$WINDOWS" = true ]; then
    x86_64-w64-mingw32-g++ $INPUT \
        -I"$RAYLIB/src" \
        "$RAYLIB/build-mingw/raylib/libraylib.a" \
        -lopengl32 -lgdi32 -lwinmm $WIN_FLAGS \
        -o "$BUILD_DIR/$OUTPUT"
else
    g++ $INPUT \
        -I"$RAYLIB/src" \
        "$RAYLIB/src/libraylib.a" \
        -lGL -lm -lpthread -ldl -lrt -lX11 \
        -o "$BUILD_DIR/$OUTPUT"
fi

if [ "$RUN" = true ]; then
    RUNPATH="$BUILD_DIR/$OUTPUT"
    if [ "$WINDOWS" = true ]; then
        RUNPATH="$RUNPATH.exe"
    fi

    echo "attempting to run $RUNPATH"
    $RUNPATH
fi 
