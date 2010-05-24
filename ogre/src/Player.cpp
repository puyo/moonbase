#include "Player.hpp"
#include <string>
#include <iostream>
#include <vector>

using namespace Moonbase;
using namespace std;

Player::Player() {
    clog << "Player::Player()" << endl;
}

Player::~Player() {
    clog << "Player::~Player()" << endl;
}

AIPlayer::AIPlayer() {
    clog << "AIPlayer::AIPlayer()" << endl;
}

AIPlayer::~AIPlayer() {
    clog << "AIPlayer::~AIPlayer()" << endl;
}

void AIPlayer::your_move(Game& game) {
    clog << "AIPlayer::your_move()" << endl;
}

HumanPlayer::HumanPlayer() {
    clog << "HumanPlayer::HumanPlayer()" << endl;
}

HumanPlayer::~HumanPlayer() {
    clog << "HumanPlayer::~HumanPlayer()" << endl;
}
