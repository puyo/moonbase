#include "game.h"

Game::Game(): _map(0), _players(10), _buildings(100), _projectiles(100) {
}

Game::~Game() {
    // Yay STL
    std::for_each(_players.begin(), _players.end(), delete_object());
    std::for_each(_buildings.begin(), _buildings.end(), delete_object());
    std::for_each(_projectiles.begin(), _projectiles.end(), delete_object());

    if (_map) {
        delete _map;
        _map = 0;
    }
}

void Game::create_building(std::string type) {} // TODO: position, player owner
void Game::create_projectile(std::string type) {} // TODO: position, angle, power, player owner
void Game::load_map(std::string name) {}

//! Generates a map randomly
void Game::generate_map() {
    log("Game::generate_map");
    _map = new Map(*this, "");
}

void Game::think(unsigned int dticks) {
}

Map *Game::map() { return _map; }
Building *Game::building(Building::ID id) { return 0; }
Projectile *Game::projectile(Projectile::ID id) { return 0; }
