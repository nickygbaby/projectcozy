# Project Cozy: Game Design

> Working title. A cozy cyberpunk life sim for Roblox.

## Pitch

You live in a tiny apartment high above **Lantern Row**, a rain-soaked, neon-lit street in a
grey megacity. Your windowsill and balcony become a little indoor garden. Downstairs you
run **Lucky Byte Noodles**, a three-stool ramen stall, and cook what you grow for tired
regulars. Bit by bit, a drab flat and one lonely street corner turn into the warmest spot in
the city.

It's *Cyberpunk 2077*'s city, seen through *Tiny Eden*'s eyes, with *Nivalis*' after-hours
heart.

## What we take from each inspiration

| Inspiration | What we borrow | What we leave behind |
|---|---|---|
| **Tiny Eden** | A futuristic-city **apartment** you fill with plants. First-person, hands-on time at home. A **plant-care ritual** (water, light, patience). Pots on the windowsill and balcony. A cat companion. Cooking what you grow and filling neighbors' orders. Buying furniture and **light fixtures**. The contrast of a muted grey city outside and a vibrant garden inside | Deep soil-chemistry simulation (too fiddly for Roblox sessions) |
| **Cyberpunk 2077** | Neon signage, wet streets, megacity scale through haze, chrome and augments, street-food culture, slang flavor ("choom") | Violence, grit, corporate dread as the main theme |
| **Nivalis** | Running a small business at night, regulars with stories, gentle routines, slice-of-life rhythm | Long text-heavy dialogue (Roblox players skim) |

## Pillars

1. **Cozy first. No fail states.** Customers who wait too long just wave and wander off. You
   never lose money, items, or progress. Tips reward speed, but slowness is never punished.
2. **Neon after dark.** The city spends most of its time at night (daytime runs 3x faster).
   Light sources are the stars of every scene.
3. **Grey city, green home.** Home is first-person, warm and alive, and it slowly fills
   with plants. The street is seen as a small diorama (narrow FOV, tilt-shift), muted except
   for neon. Scale and density come before size.
4. **Everything bounces.** Every interaction gets a springy reaction: plants pop up, the pot
   wobbles when you serve, customers hop when happy. If it doesn't squish, it isn't done.

## Core loop (built in this repo)

```
   Grow  ──►  Cook & Serve  ──►  Earn  ──►  Buy noodles / (later) upgrade & decorate
    ▲                                                        │
    └────────────────────────────────────────────────────────┘
```

1. **Grow:** At home (take the **↑ HOME** elevator next to the stall), tend windowsill pots
   and balcony planters in first person. Or climb to the shared Sky Garden. Plant →
   **Water** → it grows a stage → the soil dries (pale soil, 💧) → water again → harvest.
   About 45 seconds of watered time to ripe; harvesting gives 2. Nothing ever wilts.
2. **Buy:** Noodle Bricks come from the vending machine (4 cr).
3. **Serve:** Chibi customers pop onto the stools with an order bubble and a patience bar.
   Serve the bowl if you have the ingredients. You earn the price plus a tip of up to 50%
   for speed.
4. **Unwind:** Pet Byte the robo-cat. Watch the rain.

| Dish | Needs | Price |
|---|---|---|
| 🍜 Neon Shoyu | Noodles + Synth Scallion | 18 cr |
| 🍄 Glow Miso | Noodles + Glowshroom | 24 cr |
| 🌶️ Chrome Chili | Noodles + Scallion + Ember Chili | 40 cr |

All numbers live in `src/shared/Config.luau` and `src/shared/Items.luau`.

## Setting

- **City:** an unnamed megacity whose towers vanish into purple smog. We only ever see one
  street at a time, and that's the point.
- **Lantern Row:** a low-rise market street (south side) facing tall apartment blocks (north
  side). Warm windows show people living their lives. Lantern strings cross the street.
- **Lucky Byte Noodles:** coral-and-cream striped awning, steaming pot, three stools.
- **Byte:** a lilac robo-cat who lives on the sidewalk. Purrs in binary. Mascot material.
- **Regulars (planned):** Kiko, a courier with a busted cyberdeck. Rook, a retired chrome
  boxer who now knits. Lumi, a hacker who only orders Glow Miso. Each gets a short story arc
  told one bowl at a time.

## Roadmap

### M0: Vertical slice (this commit)
- [x] Greybox district built from code (street, skyline, stall, vending, garden, robo-cat)
- [x] Night-biased day/night cycle with keyframed neon haze
- [x] Diorama camera with rotate, zoom, tilt-shift and occluder fading (street)
- [x] Apartment + balcony above the stall, first-person at home, elevator
- [x] Tiny Eden care ritual: water → grow → dries out → water again
- [x] Zone-based audio system and lighting/audio map (docs/LIGHTING_AND_AUDIO.md)
- [x] Spring-based juice library (squash, pop-in, pop-out, hop)
- [x] Grow → serve → earn loop with saved credits and inventory
- [x] Rain, flickering neon, bobbing lanterns, HUD and toasts

### M1: Make it feel *owned*
- [ ] Furnish the apartment: place furniture, pots and **light fixtures** on a grid and earn a
      "Cozy Rating". Unlock more windowsill/balcony slots
- [ ] Neighbor orders board (Tiny Eden): requests for jars, pickles and broths, paid in
      credits + friendship
- [ ] Deeper care: light level (pots need a grow light or sunny side), fertilizer for bonus
      yield
- [ ] Byte visits the apartment and naps in the cat bed
- [ ] Stall upgrades: 4th stool, better pot (faster cook), neon sign color picker
- [ ] Cooking minigame: a short, tactile stir/pour step instead of a single prompt
- [ ] Real art pass: replace greybox parts with chunky meshes (see ART_DIRECTION.md)
- [ ] Custom chibi `StarterCharacter`

### M2: Make it feel *alive*
- [ ] Named regulars with friendship levels and story beats
- [ ] Weather variety: heavy rain, neon fog, rare "clear night" with visible stars
- [ ] Street events: night market, power outage (candle-lit service), drone parade
- [ ] More crops and dishes, plus seasonal menu

### M3: Make it *social*
- [ ] Visit friends' apartments and stalls
- [ ] Co-op service rush: one player cooks while the other serves
- [ ] Shared district decoration goals

## Monetization guardrails

Cosmetic only: apartment furniture sets, stall skins, outfits, cat accessories. Nothing that
speeds up growing or serving for money. Cozy games die when they feel like timers to pay
off.
