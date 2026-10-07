# Art & Animation Direction

**One-liner:** *A toy you could hold, plugged into a neon wall socket.*

Surfaces are soft, chunky and matte, like Tiny Eden. Light is hot, saturated and smeared
across wet ground, like Cyberpunk 2077 and Nivalis. When the two conflict, **shapes stay
cozy and light gets cyber.**

## Shape language

- **Chunky and rounded.** Big bevels (about 15–25% of the smallest dimension) on every
  modeled asset. No sharp silhouettes at the player's scale.
- **Exaggerated proportions.** Doors slightly too tall, stools slightly too fat, heads bigger
  than bodies (chibi). Things should look "squeezable".
- **Low detail, high charm.** Prefer 3 well-placed bobbles over 30 small greebles. Detail
  should read from the diorama camera at 70 studs away.
- **Slight wonkiness.** Rotate props 2–5° off-grid. Stacked boxes lean. Signs hang a bit
  crooked. Perfect alignment feels corporate. Wonky feels lived-in.

## Color

The palette lives in `src/shared/Palette.luau`.

| Role | Colors | Rule |
|---|---|---|
| City mass | Ink, Indigo, Violet, Asphalt, Concrete, Brick | Big surfaces. Dark, cool, desaturated |
| Toybox | Cream, Peach, Coral, Mint, Sky, Butter, Lilac | Anything you touch or that belongs to *you* |
| Neon | Pink, Cyan, Lime, Amber, Purple, Red | **Light sources only.** Never a wall color |

- Interactables use toybox colors, so the player's eye finds "the cozy stuff" in the dark.
- Warm windows (Butter) outnumber neon windows about 8:1. The city is lonely but people live
  here.
- Each neon sign throws real light (SurfaceLight / PointLight) in its own color onto the
  street. Color pooling on the ground is half the vibe.

## Materials

- `SmoothPlastic` for toybox surfaces: matte, soft, clay-like.
- `Neon` for emissives. Bloom (threshold 0.85) turns them into glow.
- Wet street: dark asphalt with a little reflectance, plus `Glass` puddles.
- **Avoid** high-frequency textures (brick, diamond plate) at diorama scale. They turn into
  noise and fight the toy feel.

## Lighting

Set in `AtmosphereService` (server) and `CameraController` (client):

- `Future` lighting technology so neon actually lights the scene.
- Atmosphere haze tinted per time of day: violet night, pink dawn, sickly-teal smog noon,
  magenta dusk.
- Bloom, plus a lifted saturated color grade.
- **Tilt-shift depth of field** on the client, focused on the player. This is what makes it
  read as a miniature.

## Camera

- High angle (55°), narrow FOV (32°), 70 studs back. Rotates in 45° steps with Z/C.
- The default view looks **north** at the tall neon facades and the stall's front. The south
  side is kept low-rise on purpose so it never blocks the view.
- Anything between camera and player fades to 75% transparency.

## Animation: "everything bounces"

The library is `src/shared/Juice.luau`. It's spring-based, not tween-based, because springs
overshoot and settle naturally and can be re-triggered mid-motion without popping.

| Moment | Motion | Juice call |
|---|---|---|
| Something appears | Grow from 0 with overshoot | `Juice.popIn(model)` |
| Player interacts | Squash down, stretch up, wobble to rest | `Juice.pop(target)` |
| Happy reaction | Hop with a little bounce | `Juice.hop(model)` |
| Something leaves | Anticipation bump, then shrink away | `Juice.popOut(model)` |
| Idle life | Gentle float + tiny sway | Tag `Bob` |
| Signs | Random stutter like a cheap tube | Tag `NeonFlicker` |

**Principles**
- Squash keeps the **base planted**. Objects squish *into* the ground, never float.
- Preserve volume: when it gets shorter, it gets wider.
- Stagger: when several things pop together, offset them by 30–60 ms.
- UI follows the same rules: numbers and chips bump with a `Back` ease when they change.
- Character animations (when we make a custom rig): bouncy walk with a 2-frame vertical
  squash on footfall, idle "breathing" scale on the torso, head bob slightly delayed from
  the body (overlap).

## UI

- Dark rounded "sticker" pills with a 2px neon outline. Cream text.
- `FredokaOne` for everything friendly. `Michroma` for signs, clocks and anything
  "system".
- Toasts drop in from the top with a spring and leave with a quick shrink.

## Audio (to source)

- Constant soft rain and a far-off city hum (slots in `Config.Sounds`)
- Lo-fi synth music: warm Rhodes and sidechained pads, around 70–85 BPM
- Rounded, "bloopy" UI sounds. Nothing harsh or glitchy except signs flickering
- Each customer has a tiny voice blip (Animal Crossing style), pitched per character

## Replacing greybox with real art

Every greybox piece in `DistrictBuilder.luau` is found by **name, tag or attribute**, not by
shape. To swap in a mesh:

1. Model it (Blender: big bevels, flat colors or a tiny gradient atlas, low poly).
2. Import it as a `MeshPart` or `Model` and keep the same `Name` (e.g. `Soil` inside a
   planter, the `PetPrompt` on the cat).
3. Keep the tags and attributes (`Planter`, `Crop`, `Stage`, `Bob`, `Customer`, ...).
4. Move it into `ServerStorage` and clone it from the builder instead of creating parts.
