#ifndef __Building_inc__
#define __Building_inc__

#include "GameObject.hpp"

namespace Moonbase {

    class Building : public GameObject {
        public:
            typedef boost::shared_ptr<Building> Ptr;
    };
}

#endif
