#ifndef __Map_inc__
#define __Map_inc__

#include <boost/signals.hpp>
#include <vector>
#include <string>

namespace Moonbase {

    class Map : public boost::signals::trackable {
        public:
            typedef float Height;
            typedef float Coord;
        public:
            Map();
            virtual ~Map();
            Map(const Map& other);
        public:
            void operator=(const Map& other);
        public:
            void load(const std::string& name);
            Height height(Coord x, Coord y) const; // should interpolate between known points
        private:
            typedef std::vector<Height> HeightMap; // need a formula for (x,y) <=> index such as i(x,y) = w*y + x
        private:
            HeightMap mHeights;
            dTriMeshDataID mId;

            dVector3 *mVertices;
            int mVertexCount;

            int *mIndices;
            int mIndexCount;
    };
}

#endif
