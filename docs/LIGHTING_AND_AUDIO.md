# Lighting & Audio Map

How Lantern Row should look and sound, zone by zone. Values below are the ones in the code
today (`AtmosphereService`, `DistrictBuilder`, `CameraController`, `AudioController`), so this
doc and the game stay in sync.

**The core contrast (from Tiny Eden):** the city is muted, grey and synthetic. Home and
plants are warm, saturated and alive. Neon is the bridge: it's the city's only color, and it
spills into your window at night.

---

## 1. Zone map

Top-down. +Z is north. The diorama camera looks north by default.

```
 z
 50 ┌──────────── tall north apartment blocks (18–40 high, warm windows) ─────────────┐
    │                         ┌─────────────┐                                         │
 34 │                         │  HOME TOWER │  apartment on top (floor y=48)          │
    │                         │ ▓ INDOORS ▓ │  ☀ warm ceiling lamp   ♪ RoomTone       │
 22 │   [↑HOME] [VEND]  ──────┴─ window ────┴──────                                   │
    │    ◉cyan  ◉cyan   │ LUCKY BYTE NOODLES │   ← balcony overhangs at y=48, z 17–22 │
 17 │   sidewalk  🐱    │ ◉pink sign ◉◉◉◉ red│  ♪ BrothSimmer                         │
 12 │═══ curb glow (cyan) ═══════════════════════════════════════════════════════════│
    │   ◉ lantern strings at x −40, −20, 22, 46 (pink/amber, y=14)                    │
  0 │                     WET NEON STREET      ♪ Rain  ♪ CityHum  (Alley reverb)      │
    │  ◇ spawn (−30,0)                                                                │
−12 │═══ curb glow (pink) ════════════════════════════════════════════════════════════│
    │   stairs → → → → ┐                                                              │
−22 │  low-rise market │ ┌──────── SKY GARDEN (roof y=10.4) ────────┐                 │
    │  (12–20 high)    │ │ ◉purple grow lamp row z=−30 ♪ GrowLampHum│                 │
    │                    │ ◉purple grow lamp row z=−40              │  ♪ RooftopWind  │
−50 └────────────────────┴──────────────────────────────────────────┴─────────────────┘
   x −70                   −9   0   9        20                    50                70
```

| Zone | Box (Config.Zones) | Camera | Reverb | Feel |
|---|---|---|---|---|
| **Street** | everywhere else | Diorama (55° down, FOV 32, tilt-shift) | `Alley` | Wet, neon, busy, a little lonely |
| **Rooftop** | x 20–50, y 10–24, z −50 to −22 | Diorama | `City` | Open, windy, purple grow-light glow |
| **Home** (balcony) | x −9 to 9, y 47–59, z 17–35 | **First person** | `City` | Your patch of green over the city |
| **Indoors** | x −9 to 9, y 47–59, z 22–35 | **First person** | `LivingRoom` | Warm, safe, rain muffled behind glass |

---

## 2. Global lighting

Set by `AtmosphereService` (server, replicates to everyone).

| Setting | Value | Why |
|---|---|---|
| Technology | **Future** | Neon parts and Point/SurfaceLights actually light the scene |
| GlobalShadows / ShadowSoftness | on / 0.6 | Soft toy-like shadows |
| EnvironmentDiffuse / Specular | 0.6 / 1.0 | Wet surfaces pick up sky color |
| Atmosphere | Offset 0.15, Glare 0.4, Haze 2.2 | Towers fade into smog. Scale through haze |
| Exposure | −0.15 | Keeps night dark enough for neon to read without blowing out |
| Bloom | Intensity 0.4, Size 18, **Threshold 0.95** | A soft glow on the brightest neon only. Big bloom turned the stall into a "dome" of light |
| Color grade | Saturation +0.18, Contrast +0.08, tint (255,240,250) | Slightly candy-colored |
| Tilt-shift DoF (client) | Near 0.25, Far 0.2, in-focus band = 55% of camera distance | A subtle miniature feel on the street. Off in first person |

### Time of day

The clock runs a 20-minute day, but **daytime (07:00–17:30) runs 3x faster**, so most play
happens at night. Keys are smoothstep-blended:

| Clock | Mood | Ambient | Outdoor ambient | Haze color | Brightness | Density |
|---|---|---|---|---|---|---|
| 02:00 | Deep night | (58,40,96) | (70,48,120) | violet (70,40,120) | 0.6 | 0.38 |
| 06:00 | Dawn | (110,70,110) | (170,110,140) | pink (255,150,170) | 1.6 | 0.34 |
| 12:00 | Smog noon | (110,120,120) | (160,170,160) | sickly teal (190,220,200) | 2.2 | 0.30 |
| 18:00 | Dusk | (120,70,100) | (190,100,130) | magenta (255,120,150) | 1.4 | 0.34 |
| 21:00 | Night | (70,48,110) | (80,58,140) | purple (90,50,150) | 0.8 | 0.36 |

Daytime should feel like Tiny Eden's grey megacity: flat, hazy, a bit bleak. That makes the
garden pop. Night is when the city earns its color.

---

## 3. Light-source inventory

Every light in the district, so we can watch the budget. **All brightness values come from
`Config.Lighting`.** Change one number there to dial the whole city softer or brighter.
Neon parts are 25% see-through (lit windows 50%), which dims their glow. Future lighting gets expensive
past about 60 *shadow-casting* lights on screen, and only the apartment lamp casts shadows.

| Where | Source | Color | Range | Brightness | Count | Notes |
|---|---|---|---|---|---|---|
| Building signs | SurfaceLight (front) | random neon | 12 | 0.7 | ~8–12 | about half tagged `NeonFlicker`; text brightness 1.1 |
| Stall sign "LUCKY BYTE NOODLES" | SurfaceLight | NeonPink | 12 | 0.7 | 1 | never flickers (hero sign) |
| Lantern strings | PointLight | Pink / Amber | 12 | 0.6 | 20 | sway (`Bob`) |
| Stall lanterns | PointLight | NeonRed | 10 | 0.6 | 4 | sway |
| Broth pot | PointLight | NeonAmber | 8 | 1 | 1 | plus steam particles |
| Vending holo-coin | PointLight | NeonAmber | 6 | 0.6 | 1 | spins |
| Elevator door (street) | PointLight | NeonCyan | 8 | 0.6 | 1 | |
| Sky Garden grow lamps | SurfaceLight (down) | NeonPurple | 10 | 1.2 | 2 | |
| Ripe crops | PointLight | crop color | 6 | 1.2 | 0–14 | only while ripe: "harvest me" |
| **Apartment ceiling lamp** | PointLight, **Shadows on** | warm (255,205,150) | 22 | 1.3 | 1 | the key light of home |
| Windowsill grow strip | SurfaceLight (down) | NeonPink | 6 | 1.2 | 1 | Tiny Eden "plant light" look |
| Balcony fairy lights | PointLight | Butter | 10 | 0.8 | 1 | plus 13 neon bulbs (emissive only) |
| Windows, curb glow, trims, beacons | Neon material only | various | — | — | many | bloom only, no light cost |

### Lighting rules
1. **Neon = light source, always.** If something glows, it gets a matching light or it's tiny.
2. **Warm inside, cool outside.** Home lights are amber/butter. The street is cyan/pink/purple.
   Looking out the window, you see the cool city. Looking in from the street, you see a
   warm square of home.
3. **Plants get their own light.** Grow lamps (purple outside, pink inside) mark every
   garden. Ripe crops glow in their crop color.
4. **One hero per view.** The stall sign on the street, the ceiling lamp at home, the
   grow-lamp rows on the roof.

### Next lighting work
- [ ] Turn the ceiling lamp into a placeable fixture (Tiny Eden lets you buy light fixtures).
      Each fixture style changes color temperature.
- [ ] Day: dim neon a little (Brightness × 0.6) so signs feel "off-hours".
- [ ] Rare "clear night": Atmosphere density 0.2, a Sky with stars, rain off.
- [ ] Power-outage event: kill all neon, the stall runs on candles (amber PointLights with flicker).

---

## 4. Audio map

Built by `AudioController` (client). Fill `Config.Sounds` with audio you own or licensed
Creator Store tracks.

- **One-shots work out of the box.** When their id is blank they fall back to sounds built
  into every Roblox client (the default character sounds, re-pitched): Pop, Water, Harvest,
  Coin, Nope, Elevator, Purr.
- **Loops and music stay silent** until you add ids. Roblox doesn't ship rain, city or
  music sounds.

### Mix groups

| SoundGroup | Volume | Contents |
|---|---|---|
| Music | 0.6 | `MusicNight`, `MusicHome` |
| Outside | 1.0 | `Rain`, `CityHum`: gets an EQ muffle indoors (High −30 dB, Mid −10 dB) |
| Ambience | 1.0 | `RoomTone`, `RooftopWind` |
| World | 0.9 | positional loops + 3D one-shots |
| UI | 0.7 | 2D one-shots (coin, nope, elevator) |

### Zone mix (bed volumes, crossfaded over about 1.5 s)

| Bed | Street | Rooftop | Home (balcony) | Indoors |
|---|---|---|---|---|
| Rain | 0.50 | 0.60 | 0.45 | 0.35 (muffled) |
| CityHum | 0.35 | 0.25 | 0.30 | 0.15 (muffled) |
| RoomTone | — | — | 0.08 | 0.30 |
| RooftopWind | — | 0.35 | — | — |
| MusicNight | 0.35 | 0.30 | — | — |
| MusicHome | — | — | 0.30 | 0.40 |

### Positional loops (tag `AudioEmitter` + attribute `SoundKey` on any part)

| Key | Placed on | Vol | Carries | Should sound like |
|---|---|---|---|---|
| `BrothSimmer` | stall pot | 0.5 | 30 studs | gentle bubbling + soft sizzle |
| `VendingHum` | vending machine | 0.3 | 20 | low electric hum, occasional compressor click |
| `GrowLampHum` | rooftop grow lamps | 0.2 | 18 | soft high ballast whine, very quiet |
| `Fridge` | apartment fridge | 0.2 | 14 | that 2 a.m. fridge hum. Instantly "home" |
| `NeonBuzz` | (spare) flickering signs | 0.15 | 14 | crackly tube buzz |

### One-shots

| Key | Trigger | 2D/3D | Should sound like |
|---|---|---|---|
| `Pop` | every Juice pop (plant, serve, pet) | 3D | rounded "bloop", pitch ±6% |
| `Water` | watering a planter | 3D | short watering-can pour |
| `Harvest` | harvesting | 3D | leafy rustle + soft pluck |
| `Coin` | credits go up | 2D | soft synth chime, not a slot machine |
| `Nope` | "can't do that" toast | 2D | gentle low boop (never a buzzer) |
| `Elevator` | taking the elevator | 2D | ding + whoosh |
| `Purr` | petting Byte | 3D | purr through a tiny speaker, a bit bitcrushed |

### Music direction
- **MusicNight (street/roof):** lo-fi synthwave, about 75 BPM, Rhodes + warm pads, vinyl
  crackle, sparse beat. Cyberpunk color with a cozy tempo.
- **MusicHome:** same key and tempo family, stripped down: piano or Rhodes and soft
  rain-texture, no drums. Tiny Eden's "small daily rituals" calm.
- Crossfading between them on the elevator ride should feel like closing your front door.

### Where to find audio
Creator Store → Audio. Good search terms: "rain window", "light rain loop", "city ambience
night", "room tone", "fridge hum", "bubbling pot", "vending machine hum", "water pour",
"bubble pop", "soft chime", "elevator ding", "cat purr", "lofi". Paste each id into
`Config.Sounds` as `"rbxassetid://<id>"`.
