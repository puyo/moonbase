#include "Game.hpp"
#include <string>
#include <iostream>
#include <vector>

using namespace Moonbase;
using namespace std;

Map::Map() : mId(0) {
}

Map::~Map() {
    if (mId)
        dGeomTriMeshDataDestroy(mId); 
}

void Map::load(const std::string& name) {
    clog << "Map::load() " << name << endl;

    //TODO: dGeomTriMeshDataBuildSimple(mId, vertices, vertex_count, indices, index_count); 
}
