#include <ctime>
#include "Game.h"
#include "raylib.h"
#include "states/MainMenuState.h"
Game::Game(){
    const int screenWidth = 800;
    const int screenHeight = 450;
    SetConfigFlags(FLAG_WINDOW_TOPMOST); 

    SetRandomSeed((unsigned int)time(NULL));

    InitWindow(screenWidth, screenHeight, "ONE bullet");

    SetTargetFPS(60);

    // set init state
    setState(std::make_unique<MainMenuState>());
}

Game::~Game(){
    CloseWindow();
}

void Game::loop(){
    while (!WindowShouldClose()){
        if (state->ready())
            setState(std::move(state->next));
        update();
        render();
    }
}

void Game::setState(std::unique_ptr<GameState> newState){
    if (state)
        state->exit();
    state = std::move(newState);
    state->enter();
}

void Game::update() {
    if (state) state->update();
}

void Game::render() {
    BeginDrawing();
        if (state) state->render();
    EndDrawing();
}