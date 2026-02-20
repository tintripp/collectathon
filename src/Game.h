#pragma once
#include <vector>
#include <memory>
#include "traits/Updatable.h"
#include "traits/Renderable.h"
#include "states/State.h"
class Game : public Updatable, public Renderable {
public:
    // why unique_ptr? i OWN this state! im responsible for freeing its memory!
    std::unique_ptr<GameState> state;

    Game();
    ~Game();

    void loop();
    void setState(std::unique_ptr<GameState> state);
    void update() override;
    void render() override;
};