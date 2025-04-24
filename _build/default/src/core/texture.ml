type t =
    Image of Gfx.surface
  | Color of Gfx.color

let black = Color (Gfx.color 0 0 0 255)
let white = Color (Gfx.color 255 255 255 255)
let red = Color (Gfx.color 255 0 0 255)
let green = Color (Gfx.color 0 255 0 255)
let blue = Color (Gfx.color 0 0 255 255)
let azure = Color  (Gfx.color 56 197 248 255)
let transparent = Color (Gfx.color 0 0 0 0)
let default = Color (Gfx.color 255 0 255 255)

let loadImage ctx imageLink = 
  let pending = Gfx.load_image ctx imageLink in 
  while not (Gfx.resource_ready pending) do () done;
  Image (Gfx.get_resource (pending))
;;

let draw ctx dst pos box src =
  let x = int_of_float pos.Vector.x in
  let y = int_of_float pos.Vector.y in
  let Rect.{width;height} = box in
  match src with
    Image img -> Gfx.blit_scale ctx dst img x y width height
  | Color c ->
    Gfx.set_color ctx c;
    Gfx.fill_rect ctx dst x y width height