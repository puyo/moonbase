#ifndef __GameObject_inc__
#define __GameObject_inc__

#include <boost/shared_ptr.hpp>
#include <ode/ode.h>

namespace Moonbase {
    class Game;

    class GameObject {
        public:
            typedef dBodyID ID;
            typedef boost::shared_ptr<GameObject> Ptr;
        public:
            GameObject();
            ~GameObject();
            void add_to_game(Game& game);
        private:
            // don't use these
            GameObject(const GameObject& other);
            void operator=(const GameObject& other);
        private:
            ID mId;

        friend class Game;
    };
}

#endif
