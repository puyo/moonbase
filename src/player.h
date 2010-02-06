#ifndef PLAYER_H
#define PLAYER_H 1

class Game; // forward declaration

class Player {
    public: // types

        typedef unsigned int ID;

    public: // constructors

        Player(Game& game, ID id): _game(&game), _id(id) {
        }

    public:

        ID id() const { return _id; }

    private: // data

        Game *_game;
        ID _id;
};

#endif
