#pragma once
#include "State.h"
class PlayState : public GameState{
    void update() override;
    void render() override;
    void enter() override;
    void exit() override;
};