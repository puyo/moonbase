#ifndef CLIENT_H
#define CLIENT_H 1

#include "game.h"

class Client {

    public:

        Client(Game& game) {
            _game = game;
        }
        virtual ~Client();

    public:


    private:
        Game *_game;

}

#endif
