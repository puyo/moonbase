#ifndef __MoonbaseApplication_H__
#define __MoonbaseApplication_H__

#include "Ogre.h"
#include "OgreConfigFile.h"
#include "MoonbaseFrameListener.hpp"
#include <cstdlib>

Ogre::RaySceneQuery* raySceneQuery = 0;

class MoonbaseApplication {
    public:
        /// Standard constructor
        MoonbaseApplication() {
            mFrameListener = 0;
            mRoot = 0;
            mResourcePath = "";
        }

        /// Standard destructor
        virtual ~MoonbaseApplication() {
            if (mFrameListener)
                delete mFrameListener;
            if (mRoot)
                delete mRoot;
        }

        /// Start the example
        virtual void go(void) {
            if (!setup())
                return;

            mRoot->startRendering();

            // clean up
            destroyScene();
        }

    protected:
        Ogre::Root *mRoot;
        Ogre::Camera* mCamera;
        Ogre::SceneManager* mSceneMgr;
        MoonbaseFrameListener* mFrameListener;
        Ogre::RenderWindow* mWindow;
        Ogre::String mResourcePath;

        // These internal methods package up the stages in the startup process
        /** Sets up the application - returns false if the user chooses to abandon configuration. */
        virtual bool setup(void) {
            Ogre::String pluginsPath;
            // only use plugins.cfg if not static
#ifndef OGRE_STATIC_LIB
            pluginsPath = mResourcePath + "plugins.cfg";
#endif

            mRoot = new Ogre::Root(pluginsPath, mResourcePath + "ogre.cfg", mResourcePath + "Ogre.log");

            setupResources();

            bool carryOn = configure();
            if (!carryOn) return false;

            chooseSceneManager();
            createCamera();
            createViewports();

            // Set default mipmap level (NB some APIs ignore this)
            Ogre::TextureManager::getSingleton().setDefaultNumMipmaps(5);

            // Create any resource listeners (for loading screens)
            createResourceListener();
            // Load resources
            loadResources();

            // Create the scene
            createScene();

            createFrameListener();

            // Seed random number generator
            srandom(0);

            return true;

        }

        /** Configures the application - returns false if the user chooses to abandon configuration. */
        virtual bool configure(void) {
            // Show the configuration dialog and initialise the system
            // You can skip this and use root.restoreConfig() to load configuration
            // settings if you were sure there are valid ones saved in ogre.cfg
            if(mRoot->restoreConfig()) {
                // If returned true, user clicked OK so initialise
                // Here we choose to let the system create a default rendering window by passing 'true'
                mWindow = mRoot->initialise(true);
                return true;
            } else {
                return false;
            }
        }

        virtual void chooseSceneManager(void) {
            // Create a generic SceneManager
            mSceneMgr = mRoot->createSceneManager(Ogre::ST_GENERIC);
        }

        virtual void createCamera(void) {
            // Create the camera
            mCamera = mSceneMgr->createCamera("PlayerCam");

            // Position it at 500 in Z direction
            mCamera->setPosition(Ogre::Vector3(128,25,128));
            // Look back along -Z
            mCamera->lookAt(Ogre::Vector3(0,0,-300));
            mCamera->setNearClipDistance( 1 );
            mCamera->setFarClipDistance( 1000 );
        }

        virtual void createFrameListener(void) {
            mFrameListener= new MoonbaseFrameListener(mWindow, mCamera);
            mFrameListener->showDebugOverlay(true);
            mRoot->addFrameListener(mFrameListener);
        }

        void createSphere(const std::string& strName, const float r, const int nRings = 16, const int nSegments = 16) {
            Ogre::MeshPtr pSphere = Ogre::MeshManager::getSingleton().createManual(strName, Ogre::ResourceGroupManager::DEFAULT_RESOURCE_GROUP_NAME);
            Ogre::SubMesh *pSphereVertex = pSphere->createSubMesh();

            pSphere->sharedVertexData = new Ogre::VertexData();
            Ogre::VertexData* vertexData = pSphere->sharedVertexData;

            // define the vertex format
            Ogre::VertexDeclaration* vertexDecl = vertexData->vertexDeclaration;
            size_t currOffset = 0;
            // positions
            vertexDecl->addElement(0, currOffset, Ogre::VET_FLOAT3, Ogre::VES_POSITION);
            currOffset += Ogre::VertexElement::getTypeSize(Ogre::VET_FLOAT3);
            // normals
            vertexDecl->addElement(0, currOffset, Ogre::VET_FLOAT3, Ogre::VES_NORMAL);
            currOffset += Ogre::VertexElement::getTypeSize(Ogre::VET_FLOAT3);
            // two dimensional texture coordinates
            vertexDecl->addElement(0, currOffset, Ogre::VET_FLOAT2, Ogre::VES_TEXTURE_COORDINATES, 0);
            currOffset += Ogre::VertexElement::getTypeSize(Ogre::VET_FLOAT2);

            // allocate the vertex buffer
            vertexData->vertexCount = (nRings + 1) * (nSegments+1);
            Ogre::HardwareVertexBufferSharedPtr vBuf = Ogre::HardwareBufferManager::getSingleton().createVertexBuffer(vertexDecl->getVertexSize(0), vertexData->vertexCount, Ogre::HardwareBuffer::HBU_STATIC_WRITE_ONLY, false);
            Ogre::VertexBufferBinding* binding = vertexData->vertexBufferBinding;
            binding->setBinding(0, vBuf);
            float* pVertex = static_cast<float*>(vBuf->lock(Ogre::HardwareBuffer::HBL_DISCARD));

            // allocate index buffer
            pSphereVertex->indexData->indexCount = 6 * nRings * (nSegments + 1);
            pSphereVertex->indexData->indexBuffer = Ogre::HardwareBufferManager::getSingleton().createIndexBuffer(Ogre::HardwareIndexBuffer::IT_16BIT, pSphereVertex->indexData->indexCount, Ogre::HardwareBuffer::HBU_STATIC_WRITE_ONLY, false);
            Ogre::HardwareIndexBufferSharedPtr iBuf = pSphereVertex->indexData->indexBuffer;
            unsigned short* pIndices = static_cast<unsigned short*>(iBuf->lock(Ogre::HardwareBuffer::HBL_DISCARD));

            float fDeltaRingAngle = (Ogre::Math::PI / nRings);
            float fDeltaSegAngle = (2 * Ogre::Math::PI / nSegments);
            unsigned short wVerticeIndex = 0 ;

            // Generate the group of rings for the sphere
            for( int ring = 0; ring <= nRings; ring++ ) {
                float r0 = r * sinf (ring * fDeltaRingAngle);
                float y0 = r * cosf (ring * fDeltaRingAngle);

                // Generate the group of segments for the current ring
                for(int seg = 0; seg <= nSegments; seg++) {
                    float rprime = r0 * (1 - 0.02*(float(random()) / RAND_MAX)); // make it more bumpy! - greg
                    float x0 = rprime * sinf(seg * fDeltaSegAngle);
                    float z0 = rprime * cosf(seg * fDeltaSegAngle);

                    // Add one vertex to the strip which makes up the sphere
                    *pVertex++ = x0;
                    *pVertex++ = y0;
                    *pVertex++ = z0;

                    Ogre::Vector3 vNormal = Ogre::Vector3(x0, y0, z0).normalisedCopy();
                    *pVertex++ = vNormal.x;
                    *pVertex++ = vNormal.y;
                    *pVertex++ = vNormal.z;

                    *pVertex++ = (float) seg / (float) nSegments;
                    *pVertex++ = (float) ring / (float) nRings;

                    if (ring != nRings) {
                        // each vertex (except the last) has six indices pointing to it
                        *pIndices++ = wVerticeIndex + nSegments + 1;
                        *pIndices++ = wVerticeIndex;               
                        *pIndices++ = wVerticeIndex + nSegments;
                        *pIndices++ = wVerticeIndex + nSegments + 1;
                        *pIndices++ = wVerticeIndex + 1;
                        *pIndices++ = wVerticeIndex;
                        wVerticeIndex ++;
                    }
                }; // end for seg
            } // end for ring

            // Unlock
            vBuf->unlock();
            iBuf->unlock();
            // Generate face list
            pSphereVertex->useSharedVertices = true;

            // the original code was missing this line:
            pSphere->_setBounds(Ogre::AxisAlignedBox( Ogre::Vector3(-r, -r, -r), Ogre::Vector3(r, r, r) ), false);
            pSphere->_setBoundingSphereRadius(r);
            // this line makes clear the mesh is loaded (avoids memory leaks)
            pSphere->load();
        }

        virtual void createScene(void) {
            // Ambient light
            mSceneMgr->setAmbientLight(Ogre::ColourValue(0.5, 0.5, 0.5));

            // Sky box
            //mSceneMgr->setSkyBox(true, "Moonbase/SpaceSkyBox", 50);

            // Main light
            Ogre::Light* l = mSceneMgr->createLight("MainLight");
            // Accept default settings: point light, white diffuse, just set position
            // NB I could attach the light to a SceneNode if I wanted it to move automatically with
            //  other objects, but I don't
            l->setPosition(200, 80, 50);

            // Fog
            // NB it's VERY important to set this before calling setWorldGeometry 
            // because the vertex program picked will be different
            Ogre::ColourValue fadeColour(0.93, 0.86, 0.76);
            mSceneMgr->setFog( Ogre::FOG_LINEAR, fadeColour, .001, 250, 500);
            mWindow->getViewport(0)->setBackgroundColour(fadeColour);

            // Infinite far plane?
            if (mRoot->getRenderSystem()->getCapabilities()->hasCapability(Ogre::RSC_INFINITE_FAR_PLANE)) {
                mCamera->setFarClipDistance(0);
            }

            // Planet surface
            createSphere("mySphereMesh", 100, 256, 256);
            Ogre::Entity* sphereEntity = mSceneMgr->createEntity("mySphereEntity", "mySphereMesh");
            Ogre::SceneNode* sphereNode = mSceneMgr->getRootSceneNode()->createChildSceneNode();
            //sphereEntity->setMaterialName("material_name_goes_here");
            sphereNode->attachObject(sphereEntity);

            // Set a nice viewpoint
            //mCamera->setPosition(707,2500,528);
            //mCamera->setOrientation(Quaternion(-0.3486, 0.0122, 0.9365, 0.0329));
            //mRoot -> showDebugOverlay( true );

            raySceneQuery = mSceneMgr->createRayQuery(Ogre::Ray(mCamera->getPosition(), Ogre::Vector3::NEGATIVE_UNIT_Y));
        }

        virtual void destroyScene(void){}    // Optional to override this

        virtual void createViewports(void) {
            // Create one viewport, entire window
            Ogre::Viewport* vp = mWindow->addViewport(mCamera);
            vp->setBackgroundColour(Ogre::ColourValue(0,0,0));

            // Alter the camera aspect ratio to match the viewport
            mCamera->setAspectRatio(
                    Ogre::Real(vp->getActualWidth()) / Ogre::Real(vp->getActualHeight()));
        }

        /// Method which will define the source of resources (other than current folder)
        virtual void setupResources(void) {
            // Load resource paths from config file
            Ogre::ConfigFile cf;
            cf.load(mResourcePath + "resources.cfg");

            // Go through all sections & settings in the file
            Ogre::ConfigFile::SectionIterator seci = cf.getSectionIterator();

            Ogre::String secName, typeName, archName;
            while (seci.hasMoreElements()) {
                secName = seci.peekNextKey();
                Ogre::ConfigFile::SettingsMultiMap *settings = seci.getNext();
                Ogre::ConfigFile::SettingsMultiMap::iterator i;
                for (i = settings->begin(); i != settings->end(); ++i) {
                    typeName = i->first;
                    archName = i->second;
                    Ogre::ResourceGroupManager::getSingleton().addResourceLocation(archName, typeName, secName);
                }
            }
        }

        /// Optional override method where you can create resource listeners (e.g. for loading screens)
        virtual void createResourceListener(void) { 
        }

        /// Optional override method where you can perform resource group loading
        /// Must at least do ResourceGroupManager::getSingleton().initialiseAllResourceGroups();
        virtual void loadResources(void) {
            // Initialise, parse scripts etc
            Ogre::ResourceGroupManager::getSingleton().initialiseAllResourceGroups();

        }
};

#endif
