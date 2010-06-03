#include <iostream>
#include "Game.hpp"

using namespace Moonbase;

#ifdef __cplusplus
extern "C" {
#endif

int main(int argc, char *argv[]) {

    Game game;

    Player::Ptr p1(new AIPlayer);
    game.add_player(p1);
    Player::Ptr p2(new AIPlayer);
    game.add_player(p2);

    game.load_map("longcat");
    game.start();

    game.tick(1);
    game.tick(2);
    game.tick(2.3);
    game.tick(1);

    return 0;
}

#ifdef __cplusplus
}
#endif
