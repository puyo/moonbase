#ifndef __Order_inc__
#define __Order_inc__

#include <boost/shared_ptr.hpp>

namespace Moonbase {

    class Game; // forward declaration

    /// A functor to queue orders, so we can easily do simultaneous-move later.
    class Order {
        public:
            typedef boost::shared_ptr<Order> Ptr;
            typedef double Radians;
            typedef unsigned char Power;
        public:
            Order(Player& player);
            virtual ~Order();
            virtual void process(Game& game) = 0;
    };

    class ShootOrder : public Order {
        public:
            ShootOrder(Player& player, Building& from, Radians direction, Power power);
            virtual ~ShootOrder();

            // TODO: create projectile, set its trajectory, setup collision event handling
            virtual void process(Game& game);
    };

    class SkipOrder : public Order {
        public:
            SkipOrder(Player& player);
            virtual ~SkipOrder();
            virtual void process(Game& game);
    };

    class SurrenderOrder : public Order {
        public:
            SurrenderOrder(Player& player);
            virtual ~SurrenderOrder();
            virtual void process(Game& game);
    };
}

#endif
