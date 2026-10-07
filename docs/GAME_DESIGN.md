# Project Cozy: Game Design

> Working title. A cozy cyberpunk life sim for Roblox.

## Pitch

**Lantern Row** is a rain-soaked, neon-lit street in a giant megacity, shown as a tiny
toybox diorama. You run **Lucky Byte Noodles**, a three-stool ramen stall. You grow glowing
ingredients in a rooftop garden and serve bowls to tired regulars. Bit by bit you turn one
lonely street corner into the warmest spot in the city.

It's *Cyberpunk 2077*'s city, seen through *Tiny Eden*'s eyes, with *Nivalis*' after-hours
heart.

## What we take from each inspiration

| Inspiration | What we borrow | What we leave behind |
|---|---|---|
| **Tiny Eden** | Diorama camera, chunky rounded toy shapes, squash-and-stretch on everything, soft lighting, the satisfaction of a small space slowly filling with life | Bright daytime-only palette |
| **Cyberpunk 2077** | Neon signage, wet streets, megacity scale through haze, chrome and augments, street-food culture, slang flavor ("choom") | Violence, grit, corporate dread as the main theme |
| **Nivalis** | Running a small business at night, regulars with stories, gentle routines, slice-of-life rhythm | Long text-heavy dialogue (Roblox players skim) |

## Pillars

1. **Cozy first. No fail states.** Customers who wait too long just wave and wander off. You
   never lose money, items, or progress. Tips reward speed, but slowness is never punished.
2. **Neon after dark.** The city spends most of its time at night (daytime runs 3x faster).
   Light sources are the stars of every scene.
3. **A tiny world you could hold.** The diorama camera, narrow FOV and tilt-shift blur make
   the city feel like a model on a desk. Scale and density come before size.
4. **Everything bounces.** Every interaction gets a springy reaction: plants pop up, the pot
   wobbles when you serve, customers hop when happy. If it doesn't squish, it isn't done.

## Core loop (built in this repo)

```
   Grow  ──►  Cook & Serve  ──►  Earn  ──►  Buy noodles / (later) upgrade & decorate
    ▲                                                        │
    └────────────────────────────────────────────────────────┘
```

1. **Grow:** Climb to the Sky Garden and plant Synth Scallions, Glowshrooms or Ember Chilis
   under purple grow lamps. Crops sprout, leaf out and ripen over about 45 seconds.
   Harvesting gives 2.
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
- [x] Diorama camera with rotate, zoom, tilt-shift and occluder fading
- [x] Spring-based juice library (squash, pop-in, pop-out, hop)
- [x] Grow → serve → earn loop with saved credits and inventory
- [x] Rain, flickering neon, bobbing lanterns, HUD and toasts

### M1: Make it feel *owned*
- [ ] Your own **micro-apartment** above the stall: place furniture on a grid (Tiny Eden
      building feel) and earn a "Cozy Rating"
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
