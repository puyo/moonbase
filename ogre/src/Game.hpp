#ifndef __Game_inc__
#define __Game_inc__

#include "GameObject.hpp"
#include "Map.hpp"
#include "Projectile.hpp"
#include "Player.hpp"
#include "Building.hpp"
#include "Order.hpp"
#include <boost/signals.hpp>
#include <boost/shared_ptr.hpp>
#include <map>
#include <queue>

namespace Moonbase {
    class Game : public boost::signals::trackable {
        public:
            typedef float NumSeconds;
            typedef unsigned int NumTurns;
            typedef unsigned int NumRounds;
            typedef unsigned int NumPlayers;
        public:
            Game();
        public:
            void add_player(Player::Ptr player);
            void remove_player(Player::ID playerId);

            /// Sets the order for a player for their next turn.
            void add_order(Order::Ptr order);

            /// Called periodically to advance the game state.
            void tick(NumSeconds length);

            void handle_collision(GameObject& a, GameObject& b); // ? may need quite a lot of info in GameObject
            void handle_collision(Projectile& p, Building& b); // may need something more like this

            void load_map(const std::string& name);
            void start();
        private:
            typedef std::queue<Player::ID> TurnQueue;
            typedef std::map<Player::ID, Player::Ptr> PlayersMap;
            typedef std::map<Player::ID, Order::Ptr> OrdersMap; // max 1 order per player
            typedef std::map<GameObject::ID, Projectile::Ptr> ProjectileMap;
            typedef std::map<GameObject::ID, Building::Ptr> BuildingMap;
        private:
            NumTurns mTurnsThisRound;
            NumRounds mRoundsThisGame;
            NumPlayers mMaxPlayers;
            Player::ID mPlayerIdSequence;
            Map mMap;
            TurnQueue mTurnQueue; // solves "who moves next?"
            PlayersMap mPlayers;
            ProjectileMap mProjectiles;
            BuildingMap mBuildings;
            OrdersMap mOrders; // max 1 order per player
            dWorldID mWorldId;
        private:
            boost::signal<void (Player&)> mYourTurn;
            boost::signal<void ()> mRoundOver;

        friend class GameObject;
    };
}

#endif
