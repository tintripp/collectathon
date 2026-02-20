#pragma once
#include <vector>
#include <memory>
#include "State.h"
#include "../Player.h"
#include "../defines.h"
class MainMenuState : public GameState{
private:
    std::unique_ptr<Player> plrs[GAME_MAXPLAYERS];
public:
    void update() override;
    void render() override;
    void enter() override;
    void exit() override;
};