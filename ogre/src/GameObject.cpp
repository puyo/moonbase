#include "GameObject.hpp"
#include "Game.hpp"
#include <iostream>

using namespace Moonbase;
using namespace std;

void GameObject::add_to_game(Game& game) {
    if (mId)
        dBodyDestroy(mId); 
    mId = dBodyCreate(game.mWorldId); 
}

GameObject::GameObject() {
    mId = 0; 
}

GameObject::~GameObject() {
    if (mId)
        dBodyDestroy(mId); 
}
