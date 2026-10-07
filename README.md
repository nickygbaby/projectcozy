# Project Cozy

A cozy cyberpunk life sim for Roblox: *Tiny Eden*'s toybox visuals and bouncy animation, with
*Cyberpunk 2077* and *Nivalis* neon-night vibes. Run a tiny noodle stall on a rain-soaked
street, grow glowing ingredients on the roof and pet the robo-cat.

- 📖 [Game design](docs/GAME_DESIGN.md): pitch, pillars, core loop, roadmap
- 🎨 [Art & animation direction](docs/ART_DIRECTION.md): shapes, palette, lighting, the "everything bounces" rules

## Getting it into Roblox Studio

The project uses [Rojo](https://rojo.space) to sync code from this repo into Studio.

1. Install [Rokit](https://github.com/rojo-rbx/rokit), then run `rokit install` in this
   folder. That installs Rojo, StyLua and Selene at the pinned versions.
2. Install the Rojo plugin in Studio (`rojo plugin install`, or get it from the Creator Store).
3. Run `rojo serve`, open a **new Baseplate** in Studio, delete the default `Baseplate`
   part, then click **Connect** in the Rojo plugin.
4. Press **Play**. The whole district is built by code at runtime, so there's nothing to place
   by hand.

To build a place file instead: `rojo build -o ProjectCozy.rbxlx`.

**Saving:** progress uses DataStores. In Studio, turn on *Game Settings → Security → Enable
Studio Access to API Services*. Without it the game still runs, but progress isn't saved.

## Controls

| Action | Keyboard / Mouse | Gamepad |
|---|---|---|
| Move | WASD | Left stick |
| Interact | E (prompt key) | X |
| Rotate camera 45° | Z / C | L1 / R1 |
| Zoom | Mouse wheel | — |
| Toggle diorama / normal camera | V | — |

## Project layout

```
src/
  shared/              → ReplicatedStorage.Shared
    Config.luau          every tunable number
    Palette.luau         the color palette
    Items.luau           ingredients + recipes
    Juice.luau           spring squash/stretch/pop animation library
  server/              → ServerScriptService.Server
    Main.server.luau     boots the services
    Services/
      AtmosphereService    lighting, haze, night-biased day/night cycle
      DistrictBuilder      builds Lantern Row (greybox) from code
      PlayerDataService    credits/inventory, DataStore save, mirrored to attributes
      GardenService        rooftop planters: plant → grow → harvest
      StallService         chibi customers, orders, serving, tips
      InteractionsService  vending machine, petting Byte the robo-cat
      Notify               toast/pop remotes
  client/              → StarterPlayerScripts.Client
    Main.client.luau     boots the controllers
    Controllers/
      CameraController     diorama camera, tilt-shift, occluder fading
      AmbientController    Bob / Spin / NeonFlicker tags, customer reactions, Pop remote
      PlantVisuals         draws crops from planter attributes
      HudController        credits, clock, inventory, toasts
      RainController       rain particles + ambience loops
```

### Architecture rule of thumb

**The server owns state. The client owns feel.** The server sets attributes, tags and
prompts (`Stage = 2`, `Mood = "happy"`, tag `Bob`). The client watches those and does all
the animation locally, which keeps it smooth and replication cheap. New content should
follow the same pattern.

## Tooling

```sh
stylua src          # format
selene src          # lint
```
