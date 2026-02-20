#include <memory>
#include "PlayState.h"
#include "MainMenuState.h"
#include "raylib.h"

void PlayState::update(){
    if(IsKeyPressed(KEY_J)){
        transition(std::make_unique<MainMenuState>());
    }
}
void PlayState::render(){
    ClearBackground(BLUE);
}
void PlayState::enter(){}
void PlayState::exit(){}