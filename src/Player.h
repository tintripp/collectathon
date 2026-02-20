#pragma once
#include "traits/Updatable.h"
#include "traits/Renderable.h"
#include "raylib.h"
class Player : public Updatable, public Renderable {
public:
    float x,y;
    int w,h;
    Color c;
    int gamepad;

    Player(int x, int y, Color c);

    void update() override;
    void render() override;
};