open Component_defs


type t = {
  window : Gfx.window;
  ctx : Gfx.context;
  mutable player : player; 
  crosshair : crosshair ; 
  mutable waiting : int;
  mutable list_ai : abstract_ai list ;
  mutable list_block : block list ;
}

let state = ref None

let set s = state := Some s

let get () : t =
  match !state with
    None -> failwith "Uninitialized global state"
  | Some s -> s
;;

let chrono_bullet : float ref = ref (-.100.0)


let global_id = ref Int64.zero 

(*Hands out a new unique Integer as an ID : Does not recycle value, since int64 is "big enough" *)
let new_ID () = 
  let result = Int64.add (!global_id) Int64.one in 
  global_id := Int64.add (!global_id) Int64.one; 
  if ( Int64.equal !global_id Int64.zero ) then 
    failwith "Maximum amount of ID holder reached !" 
  else 
    result 




let pop_ai (id_ : id) = 
  (*Totalement pas opti.*)
  let condition (e : abstract_ai) = (Int64.equal id_#id#get  e#id#get) in 
  let l = (get ()).list_ai in 
  let _, l2 = List.partition condition l in 
  (get ()).list_ai <- l2 ; 
;;

let get_ai (id_: id) = 
  let condition (e : abstract_ai) = (Int64.equal id_#id#get  e#id#get) in 
  let l = (get ()).list_ai in 
  List.find_opt condition l 

;;

let add_ai (instance : abstract_ai) = 
  (get ()).list_ai <- instance :: (get ()).list_ai ; 
;;

let clean_ai () = 
  global_id := Int64.zero; 
  List.iter (fun (a : abstract_ai) -> a#unregister#get (a :> id)) (get ()).list_ai;
  (get ()).list_ai <- []; 

;;



let postGlobalCreation_assignTexture p cst_textureLink= 
  let ctx = (get()).ctx in 
  let cst_texture = Texture.loadImage (ctx) (cst_textureLink) in 
  p#texture#set cst_texture ;
;;


let rec assignPlatformTexture (instance : block list) link =
  match instance with
  | [] -> ()
  | b :: q -> 
    postGlobalCreation_assignTexture (b :> texture) link;
    assignPlatformTexture q link;
;;