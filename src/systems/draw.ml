open Ecs
open Component_defs


type t = drawable

let init _ = ()

let white = Gfx.color 255 255 255 255

let update _dt el =
  let Global.{window;ctx;_} = Global.get () in
  let surface = Gfx.get_surface window in
  let ww, wh = Gfx.get_context_logical_size ctx in
  (*Gfx.set_color ctx white;
  Gfx.fill_rect ctx surface 0 0 ww wh;*)
  let backgroundSurface = Texture.loadImage ctx (Cst.cst_bg) in
  let backgroundBox = Rect.{width = ww; height = wh} in 
  Texture.draw ctx surface (Vector.{x=0.; y=0.}) backgroundBox backgroundSurface ; 
  Seq.iter (fun (e:t) ->
      let pos = e#position#get in
      let box = e#box#get in
      let txt = e#texture#get in
      (*Format.eprintf "%a\n%!" Vector.pp pos;*)
      Texture.draw ctx surface pos box txt
    ) el;
  Gfx.commit ctx