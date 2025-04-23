open Ecs

class position () =
  let r = Component.init Vector.zero in
  object
    method position = r
  end

class velocity () =
  let r = Component.init Vector.zero in
  object
    method velocity = r
  end

(*If true : reset Velocity for each Move system's loop*)
class brake() = 
  let r = Component.init true in 
  object 
    method brake = r 
  end 

(*If true, ajust the velocity of an instance to avoid it overshooting a collidable through sheer speed*)
(*Expensive to compute*)
class requiresRayCast () = 
  let r = Component.init false in 
  object 
    method requiresRayCast = r 
  end 

class mass () =
  let r = Component.init 0.0 in
  object
    method mass = r
  end

class forces () =
  let r = Component.init Vector.zero in
  object
    method forces = r
  end

class box () =
  let r = Component.init Rect.{width = 0; height = 0} in
  object
    method box = r
  end

(*If a collidable object is in contact of another one*)
class isInContact() = 
  let r = Component.init false in 
  object 
    method isInContact = r 
  end 

class texture () =
  let r = Component.init (Texture.Color (Gfx.color 0 0 0 255)) in
  object
    method texture = r
  end

(*Tag declaration*)
type tag = ..
type tag += Null_ 
type tag += Body 
type tag += Player
type tag += Terrain
type tag += Crosshair_
type tag += HWall 
type tag += VWall 
type tag += Bullet

class tagged () =
  let r = Component.init Null_ in
  object
    method tag = r
  end

class resolver () =
  let r = Component.init (fun (_ : Vector.t) (_ : tag) -> ()) in
  object
    method resolve = r
  end

class score1 () =
  let r = Component.init 0 in
  object
    method score1 = r
  end
class score2 () =
  let r = Component.init 0 in
  object
    method score2 = r
  end

(*Destruction related component*)
class hitBox() = 
  let r = Component.init Rect.{width = 0; height = 0} in 
  object 
    method hitBox = r 
end 

class hurtBox() = 
  let r = Component.init Rect.{width = 0; height = 0} in 
  object 
    method hurtBox = r 
  end   

class damage() = 
  let r = Component.init (0.0) in 
  object 
      method damage = r 
  end 

class healthPoint() = 
  let r = Component.init (0.0) in 
  object 
    method healthPoint = r 
  end 

class relativeHitBox() = 
  let r = Component.init (Vector.zero) in 
  object 
    method relativeHitBox = r 
  end 

class relativeHurtBox() = 
  let r = Component.init (Vector.zero) in 
  object 
    method relativeHurtBox = r 
  end 

(*The tag of the Destructible's Hurtboxs this instance's Hitbox has collided with. *)
class impactInfo() = 
  let r = Component.init (Null_::[]) in 
  object 
    method impactInfo = r 
  end 

(*A list of tag; when computing impactInfo, impactInfo will ignore any instances with one of those tags.*)
class protectedTag() = 
  let r = Component.init(Null_::[]) in 
  object
    method protectedTag = r 
  end

(*IA related component*)
class behavior() = (*Index, indicates which "behavior" to use in the state_machine*)
    let r = Component.init (0) in 
    object 
      method behavior = r 
    end 


class id() = (*Unique int64 attributed to each ia instance*)
    let  r = Component.init (Int64.one) in 
    object 
      method id = r
    end 


class state_machine() = (*Define the behavior for an ia instance*)
    let r = Component.init ( fun (_ : id) -> ()  ) in 
    object 
      method state_machine = r 
    end 


  class unregister() = (*Allows a class instance to delete itself.*)
    let  r = Component.init (fun (_ : id) -> ()) in 
    object 
      method unregister = r 
    end 




(** Archetype *)
class type movable =
  object
    inherit Entity.t
    inherit position
    inherit velocity
    inherit brake 
  end

class type collidable =
  object
    inherit Entity.t
    inherit position
    inherit box
    inherit mass
    inherit velocity
    inherit resolver
    inherit tagged
    inherit forces

    inherit isInContact 
    inherit requiresRayCast (*Not a feature for now, TODO ?*)
  end

class type physics =
  object 
    inherit Entity.t
    inherit mass
    inherit forces
    inherit velocity
  end

class type drawable =
  object
    inherit Entity.t
    inherit position
    inherit box
    inherit texture
  end

class type destructible = 
  object 
    inherit Entity.t 
    inherit tagged 
    inherit impactInfo
    inherit protectedTag

    inherit position

    inherit hitBox 
    inherit relativeHitBox
    inherit damage

    inherit hurtBox
    inherit relativeHurtBox
    inherit healthPoint 

  end 

class type ai = 
  object 
    inherit Entity.t 

    inherit behavior 
    inherit state_machine 

    inherit id 

    inherit unregister 
  end 

(** Real objects *)
class abstract_ai name  = 
  object 
    inherit Entity.t ~name()
    inherit id()
    inherit tagged()
    inherit impactInfo()
    inherit protectedTag() (*Depends*)

    inherit texture() 

    inherit position()
    inherit box ()
    inherit requiresRayCast() (*Depends*)
    inherit isInContact ()
    inherit brake()

    inherit mass()
    inherit forces()
    inherit velocity()
    inherit resolver()

    inherit hitBox()
    inherit relativeHitBox()
    inherit damage()

    inherit hurtBox()
    inherit relativeHurtBox()
    inherit healthPoint()

    inherit behavior()
    inherit state_machine()
    inherit unregister()
  end 

class player name = 
  object
    inherit Entity.t ~name() 
    inherit tagged() 
    inherit impactInfo()
    inherit protectedTag() (*Empty*)

    inherit texture()

    inherit position()
    inherit box()
    inherit requiresRayCast() (*false*)
    inherit isInContact ()
    inherit brake ()

    inherit mass()
    inherit forces()
    inherit velocity()
    inherit resolver()

    inherit hitBox()
    inherit relativeHitBox()
    inherit damage()

    inherit hurtBox()
    inherit relativeHurtBox()
    inherit healthPoint()
  end 

class crosshair = 
  object 
    inherit Entity.t ()

    inherit texture()

    inherit position()
    inherit box()
    inherit brake()

    inherit velocity()
  end 

class block () =
  object
    inherit Entity.t ()
    inherit position ()
    inherit box ()

    inherit requiresRayCast() (*false*)
    inherit isInContact ()
    inherit brake ()

    inherit resolver ()
    inherit tagged ()
    inherit texture ()
    inherit mass ()
    inherit forces ()
    inherit velocity ()
  end
