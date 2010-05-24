#ifndef __Projectile_inc__
#define __Projectile_inc__

#include "GameObject.hpp"
#include <boost/shared_ptr.hpp>

namespace Moonbase {
    class Projectile : public GameObject {
        public:
            typedef boost::shared_ptr<Projectile> Ptr;
    };
}

#endif
