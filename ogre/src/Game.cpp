#include "Game.hpp"
#include <string>
#include <iostream>
#include <vector>

using namespace Moonbase;
using namespace std;

Game::Game(): mMaxPlayers(0), mPlayerIdSequence(0) {
    clog << "Game::Game()" << endl;
}

void Game::add_player(Player::Ptr player) {
    clog << "Game::add_player()" << endl;
    player->set_id(mPlayerIdSequence++);
    mPlayers[player->id()] = player;
}

void Game::remove_player(Player::ID player_id) {
    clog << "Game::remove_player()" << endl;
    mPlayers.erase(player_id);
}

void Game::add_order(Order::Ptr order) {
    clog << "Game::add_order()" << endl;
}

void Game::tick(NumSeconds length) {
    clog << "Game::tick() " << length << endl;
}

void Game::handle_collision(GameObject& a, GameObject& b) {
}

void Game::handle_collision(Projectile& p, Building& b) {
}

void Game::start(){
    clog << "Game::start()" << endl;

    // Set up the turn queue

    for(PlayersMap::iterator i = mPlayers.begin(); i != mPlayers.end(); ++i){
        mTurnQueue.push((*i).first);
    }

    // Tell the first player on the queue that it's their move
    mPlayers[mTurnQueue.front()]->your_move(*this);
}

void Game::load_map(const string& name){
    clog << "Game::load_map() " << name << endl;
    mMap.load(name);
}
