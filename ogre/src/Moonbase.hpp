#ifndef __Moonbase_inc__
#define __Moonbase_inc__

#include <Ogre.h>

namespace Moonbase {

    /** Abstract class representing a world object.  
     *
     * This is what you subclass and load with a mesh.  It has functionality to:
     * - play a default animation for idling and moving (ie walking)
     * - Scale, move, rotate over time
     * - highlight w/ bounding box
     * Specific functionality or animation sequences come from the derived class.
     */
    class DisplayObject : public Ogre::UserDefinedObject { 
        protected:
            std::string mName;                      ///< My name/ID
            Ogre::SceneManager *mSceneMgr;          ///< Current Scene manager 
            Ogre::Entity *mEntity;                  ///< My entity
            Ogre::SceneNode *mNode;                 ///< Node I'm attached to
            Ogre::AnimationState *mAnimationState;  ///< Holds animation state
            Ogre::RaySceneQuery *mRaySceneQuery;    ///< For maintaining personal space
            Ogre::Vector3 mInitFacing;              ///< Initial facing vector for mesh
            Ogre::Quaternion mInitOrientOffset;     ///< Quaternion form of mInitFacing

            // Programmed / self-managed rotation state variables
            bool mProgRotating;                     ///< Programmed rotation 
            Ogre::Quaternion mProgOrientSrc;        ///< Intial rotation orientation
            //Ogre::Quaternion mProgOrientIntA;     ///< Used for squad, if desired
            //Ogre::Quaternion mProgOrientIntB;     ///< Used for squad, if desired
            Ogre::Quaternion mProgOrientDest;       ///< Dest rotation orientation
            Ogre::Real mProgRotateProgress;         ///< How far between the two
            Ogre::Real mProgRotateTime;             ///< How long it should take
            Ogre::Node::TransformSpace mProgTransformSpace;   ///< Which axis set to rotate in

            // Programmed / self-managed movement state variables
            std::deque<Ogre::Vector3> mMoveList;    ///< List of points to move to
            bool mProgMoving;                       ///< Programmed movement
            Ogre::Vector3 mProgDestination;         ///< Next destination point
            Ogre::Vector3 mProgDirection;           ///< Direction object is moving
            Ogre::Real mProgDistance;               ///< Distance to next movepoint

            // Influenced / Continuous transformation (PerSecond functions)
            Ogre::Vector3 mTranslation;             ///< One-time translation
            Ogre::Vector3 mContMovement;            ///< Outside influenced movement
            Ogre::Real mContYaw;
            Ogre::Real mContPitch;
            Ogre::Real mContRoll;

            // Object properties
            Ogre::Real mMoveSpeed;                  ///< Speed object moves
            Ogre::Real mRotateSpeed;                ///< Speed object rotates in radians
            Ogre::Real mOrbitDistance;              ///< If a dest point is within this distance, we may go into orbit 
            bool mGrounded;                         ///< Is object stuck to ground?
            bool mBounded;                          ///< Is object bounded by geometry?
            Ogre::Real mPersonalSpace;              ///< Keep this far away from objects

        public:
            Object(); 
            Object(const std::string &name); 
            Object(const std::string &name, const std::string &mesh, const Ogre::Vector3 &facing, const Ogre::Vector3 &startPoint);

            virtual ~Object();

            // getTypeName used for UserDefinedObject
            virtual const std::string& getTypeName() const;

            virtual bool frameStarted(const Ogre::FrameEvent &evt);
            virtual bool frameEnded(const Ogre::FrameEvent &evt);

            // Programmed / Self managed & continuous transformation functions
            virtual void progRotate(const Ogre::Quaternion &quat, Ogre::Node::TransformSpace = Ogre::Node::TS_LOCAL);
            virtual void yawPerSecond(Ogre::Real r = 1.0);          
            virtual void pitchPerSecond(Ogre::Real r = 1.0);
            virtual void rollPerSecond(Ogre::Real r = 1.0);
            virtual void stopRotating();
            virtual void resetYAxis(bool instant=false, Ogre::Node::TransformSpace= Ogre::Node::TS_PARENT);
            virtual void resetOrientation(bool instant=false, Ogre::Node::TransformSpace= Ogre::Node::TS_PARENT);

            virtual void movePerSecond(const Ogre::Vector3 &v);
            virtual void stopMoving();

            virtual void defaultAnimation()=0;                  ///< set "Idle" function
            virtual void newLocation(const Ogre::Vector3 &v)=0; ///< set "Walk" function

            // Instant transformation functions
            virtual void highlight(bool b);
            virtual void setPosition(const Ogre::Vector3 &v); 
            virtual void translate(const Ogre::Vector3 &v); 
            virtual void rotate(const Ogre::Quaternion &quat, Ogre::Node::TransformSpace = Ogre::Node::TS_LOCAL);
            virtual void yaw(Ogre::Real r);                 
            virtual void pitch(Ogre::Real r);                 
            virtual void roll(Ogre::Real r);                 
            virtual void setScale(const Ogre::Vector3 &v);
            virtual void setScale(float x, float y, float z); 

            // Object properties functions 
            virtual void setMoveSpeed(Ogre::Real speed);
            virtual Ogre::Real getMoveSpeed();
            virtual void setRotateSpeed(Ogre::Real speed);
            virtual Ogre::Real getRotateSpeed();
            virtual void setGrounded(bool b);
            virtual bool getGrounded();
            virtual void setBounded(bool b);
            virtual bool getBounded();
            virtual void setPersonalSpace(Ogre::Real space);
            virtual Ogre::Real getPersonalSpace();
            virtual bool isMoving();
            virtual Ogre::SceneNode* getNode();
            virtual Ogre::Entity* getEntity();

        protected: 
            virtual void mInit(const std::string &name, const std::string &mesh, const Ogre::Vector3 &facing, const Ogre::Vector3 &startPoint);
            virtual bool mNextLocation();
            virtual void mProcessRotation(const Ogre::FrameEvent &evt);
            virtual void mProcessMovement(const Ogre::FrameEvent &evt);
            virtual void mCheckBounds(Ogre::Vector3 *movement);
            virtual Ogre::Real mSceneQueryDistance(const Ogre::Ray &myRay, bool sort=true);

    }; // class Object

}

#endif
