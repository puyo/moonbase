#ifndef __Player_inc__
#define __Player_inc__

#include <boost/signals.hpp>
#include <boost/shared_ptr.hpp>

namespace Moonbase {
    class Game; // forward declaration

    class Player {
        public: // types
            typedef unsigned int ID;
            typedef boost::shared_ptr<Player> Ptr;
        public:
            Player();
            virtual ~Player();
            const std::string& name() const { return mName; };
            ID id() const { return mId; };
            void set_id(ID id) { mId = id; }
            void set_name();
            virtual void your_move(Game& game) = 0;
        private:
            std::string mName;
            ID mId;
    };

    class HumanPlayer : public Player {
        public:
            HumanPlayer();
            virtual ~HumanPlayer();
            virtual void your_move(Game& game) {};
    };

    class AIPlayer : public Player {
        public:
            AIPlayer();
            virtual ~AIPlayer();
            virtual void your_move(Game& game);
    };
}

#endif
