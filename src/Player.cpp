#include "Player.h"
#include "raylib.h"
#include <stdio.h>
#include <cmath>

Player::Player(int x, int y, Color c){
    this->x = x;
    this->y = y;
    w=16;
    h=16;
    this->c = c;
}

void Player::update(){
    float leftStickX = GetGamepadAxisMovement(gamepad, GAMEPAD_AXIS_LEFT_X);
    float leftStickY = GetGamepadAxisMovement(gamepad, GAMEPAD_AXIS_LEFT_Y);
    float deadzone = 0.2f;
    float speed = 5.1f;
    if (std::abs(leftStickX) > deadzone) x += leftStickX * speed;
    if (std::abs(leftStickY) > deadzone) y += leftStickY * speed;
}
void Player::render(){
    DrawRectangle(x,y,w,h,c);
}