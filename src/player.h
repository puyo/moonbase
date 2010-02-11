#ifndef PLAYER_H
#define PLAYER_H 1

class Game;

class Player {
    public:
        typedef unsigned int ID;
    public:
        Player(Game& game, ID id): _game(&game), _id(id) { }
    public:
        ID id() const { return _id; }
    private:
        Game *_game;
        ID _id;
};

#endif
