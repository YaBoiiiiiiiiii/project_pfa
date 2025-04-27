open Ecs
open Component_defs

type t = destructible 

let init _ = ()

let rec iter_pairs f s =
  match s () with
    Seq.Nil -> ()
  | Seq.Cons(e, s') ->
    Seq.iter (fun e' -> f e e') s';
    iter_pairs f s'

let update _ el =

  let setImpactInfo instance data = 
    instance#impactInfo#set (data::(instance#impactInfo#get))
  in

  let compareTag (a : tag) (b : tag) = 
    if (tagToInt a) = (tagToInt b) then 
      true
    else 
      false
    ;
  in 

  (*Empty all instance's impactInfo attributes*)
  Seq.iter(fun (e:t) -> e#impactInfo#set [] ) el;

  (*Resolve Hurtbox/Hitbox interraction*)
  el
  |> iter_pairs (fun (e1:t) (e2:t) ->

      let pos_1 = e1#position#get in
      let pos_2 = e2#position#get in
      
      let pos_hurtBox_1 = Vector.add pos_1 e1#relativeHurtBox#get in 
      let pos_hurtBox_2 = Vector.add pos_2 e2#relativeHurtBox#get in 

      let pos_hitBox_1 = Vector.add pos_1 e1#relativeHitBox#get in 
      let pos_hitBox_2 = Vector.add pos_2 e2#relativeHitBox#get in 

      let hurtbox_1 = e1#hurtBox#get in 
      let hurtbox_2 = e2#hurtBox#get in 

      let hitbox_1 = e1#hitBox#get in 
      let hitbox_2 = e2#hitBox#get in 


      (*Change HealthPoint/Damage attributes and ImpactInfo on Hitbox/HurtBox interraction*)
      (*check if e1 is hit by e2*)
      match Rect.rebound pos_hurtBox_1 hurtbox_1 pos_hitBox_2 hitbox_2 with
        None -> ()
      | Some v -> (*Contact*)
        let oper = compareTag e1#tag#get in 
        (*If e1's tag is in e2's protectedTag list : skip*)
        match (List.find_opt(oper)(e2#protectedTag#get)) with 
        |Some _ -> () 
        |None ->
          begin
            e1#healthPoint#set (e1#healthPoint#get -. e2#damage#get) ;
            setImpactInfo e2 e1#tag#get ; 
          end 
      ;
         
      (*check if e2 is hit by e1*)
      match Rect.rebound pos_hurtBox_2 hurtbox_2 pos_hitBox_1 hitbox_1 with
        None -> ()
      | Some v -> (*Contact*)
        let oper = compareTag e2#tag#get in 
        (*If e2's tag is in e1's protectedTag list : skip*)
        match (List.find_opt(oper)(e1#protectedTag#get)) with 
        |Some _ -> () 
        | None ->
          begin
            e2#healthPoint#set (e2#healthPoint#get -. e1#damage#get) ;
            setImpactInfo e1 e2#tag#get ; 
          end 
        ;
        
  )
       
