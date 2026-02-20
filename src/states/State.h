#pragma once
#include <memory>
#include "../traits/Updatable.h"
#include "../traits/Renderable.h"
class GameState : public Updatable, public Renderable {
private:
    bool done = false;
public:
    std::unique_ptr<GameState> next; 

    virtual void update() override = 0;
    virtual void render() override = 0;
    virtual void enter() = 0;
    virtual void exit() = 0;
    inline bool ready(){
        return done && next;
    };
    inline void transition(std::unique_ptr<GameState> state){
        next = std::move(state);
        done = true;
    };
    virtual ~GameState() = default;
};