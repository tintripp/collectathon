#!/bin/bash

WINDOWS=false
WIN_FLAGS=""

RUN=false

INPUT="$(find src -type f \( -name '*.c' -o -name '*.cpp' \))"
OUTPUT="a"

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
        *)
            echo "Unknown option: $1"
            shift
            ;;
    esac
done

#################################################

RAYLIB="./raylib"

# ensure raylib exists
if [ ! -d "$RAYLIB" ]; then
    echo "Cloning raylib..."
    git clone https://github.com/raysan5/raylib.git
fi

# Set platform-specific library path
if [ "$WINDOWS" = true ]; then
    RAYLIB_BUILD_DIR="$RAYLIB/build-mingw/raylib"
else
    RAYLIB_BUILD_DIR="$RAYLIB/src"
fi
RAYLIB_LIB="$RAYLIB_BUILD_DIR/libraylib.a"

# Make sure the build folder exists
mkdir -p "$RAYLIB_BUILD_DIR"

# Build raylib if does not exist
if [ ! -f "$RAYLIB_LIB" ]; then
    echo "Raylib not built for $( [ "$WINDOWS" = true ] && echo Windows || echo Linux ). Building now..."

    if [ "$WINDOWS" = true ]; then
        RAYLIB_BUILD_DIR="raylib/build-mingw"
        mkdir -p "$RAYLIB_BUILD_DIR"
        cd "$RAYLIB_BUILD_DIR"
        cmake .. \
            -G "Unix Makefiles" \
            -DCMAKE_SYSTEM_NAME=Windows \
            -DCMAKE_C_COMPILER=x86_64-w64-mingw32-gcc \
            -DCMAKE_CXX_COMPILER=x86_64-w64-mingw32-g++ \
            -DBUILD_SHARED_LIBS=OFF \
            -DBUILD_EXAMPLES=OFF
        make
        cd ../..
    else
        make -C "$RAYLIB/src" PLATFORM=PLATFORM_DESKTOP
    fi
fi

#################################################

BUILD_DIR="build/"
RES="res/"

# create build folder
mkdir -p "$BUILD_DIR"

# copy resources
if [ "$WINDOWS" = true ]; then
    BUILD_DIR="$BUILD_DIR/win32/"
else
    BUILD_DIR="$BUILD_DIR/unix/"
fi

DEST="$BUILD_DIR/$RES"

mkdir -p "$DEST"
rsync -a --delete "$RES/" "$DEST/"

#################################################

# build the program
if [ "$WINDOWS" = true ]; then
    x86_64-w64-mingw32-g++ $INPUT \
        -I"$RAYLIB/src" \
        "$RAYLIB_LIB" \
        -lopengl32 -lgdi32 -lwinmm $WIN_FLAGS \
        -o "$BUILD_DIR/$OUTPUT" \
        -static -static-libgcc -static-libstdc++
else
    g++ $INPUT \
        -I"$RAYLIB/src" \
        "$RAYLIB_LIB" \
        -lGL -lm -lpthread -ldl -lrt -lX11 \
        -o "$BUILD_DIR/$OUTPUT"
fi

# run
if [ "$RUN" = true ]; then
    RUNPATH="$BUILD_DIR/$OUTPUT"
    if [ "$WINDOWS" = true ]; then
        RUNPATH="$RUNPATH.exe"
    fi

    echo "attempting to run $RUNPATH"
    $RUNPATH
fi 
