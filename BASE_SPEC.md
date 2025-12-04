# Melee Combat RL Environment

## Overview

Train AI agents to fight each other in melee combat using reinforcement learning. Fork the Godot4ThirdPersonCombatPrototype and integrate godot_rl_agents to create a self-play training environment.

## Project Structure
```
Godot4ThirdPersonCombatPrototype/ (forked)
├── addons/
│   └── godot_rl_agents/ (plugin)
├── scenes/
│   ├── training_arena.tscn (new - the RL environment)
│   └── (existing scenes)
├── scripts/
│   ├── ai_controller.gd (new - RL interface)
│   └── (existing combat scripts)
└── python/
    └── train.py (training script)
```

## Phase 1: Strip Down Prototype

Remove:
- Enemy AI / behavior trees (Beehave)
- Single-player game flow
- UI/HUD not needed for training
- Camera follow logic (replace with fixed arena camera)

Keep:
- Player character with animations
- Combat system (attack, block, hit detection)
- Hitbox timing (active only during swing frames)
- Stamina system
- Animation state machine

## Phase 2: Build Training Arena

**Arena:**
- Flat plane with walls
- Fixed overhead or angled camera to see both fighters
- Small enough to force engagement

**Agents:**
- Two instances of fighter character
- Identical stats, same policy (self-play)
- Each controlled by AIController3D node

## Phase 3: RL Integration

### Action Space

Continuous:
- `move`: -1.0 (backward) to 1.0 (forward)
- `turn`: -1.0 (left) to 1.0 (right)

Discrete:
- `0`: nothing
- `1`: attack
- `2`: block

### Observation Space

| Observation       | Type    | Range/Values                          |
|-------------------|---------|---------------------------------------|
| distance_to_enemy | float   | normalized, 0.0 - 1.0                 |
| angle_to_enemy    | float   | -1.0 (behind left) to 1.0 (behind right) |
| own_state         | int     | 0=idle, 1=attacking, 2=blocking, 3=recovering |
| enemy_state       | int     | 0=idle, 1=attacking, 2=blocking, 3=recovering |
| own_stamina       | float   | 0.0 - 1.0                             |

Note: enemy stamina intentionally hidden — agent must infer from behavior.

### Combat Mechanics

- **Attack:** windup animation, hitbox active only during swing frames, recovery period after, costs stamina, fails if stamina empty
- **Block:** hold to block, reduces movement speed, drains stamina passively while held
- **Stamina:** regenerates when not attacking or blocking

### Rewards

| Event              | Reward  |
|--------------------|---------|
| Land a hit         | +1.0    |
| Take a hit         | -1.0    |
| Per step (time)    | -0.001  |

### Episode Termination

- One agent reaches 0 HP (5 hits to kill)
- Timeout (max steps reached)

## Phase 4: Training

### Setup

1. Install godot_rl_agents plugin in Godot project
2. Add Sync node to training arena scene
3. Create Python training script using StableBaselines3

### Training Modes

- **With visualization:** `python train.py --viz` (watch agents fight, slower)
- **Headless:** `python train.py` (faster, monitor via TensorBoard)
- **Evaluation:** load trained model, fight it yourself or watch

## Validation Checkpoints

Before full implementation, validate:

1. [ ] Prototype runs in Godot with Blender installed
2. [ ] Can spawn two player characters in same scene
3. [ ] godot_rl_agents plugin installs and example works
4. [ ] Can control character via script (not input)
5. [ ] Combat system works between two characters

## References

- Godot4ThirdPersonCombatPrototype: https://github.com/Snaiel/Godot4ThirdPersonCombatPrototype
- godot_rl_agents: https://github.com/edbeeching/godot_rl_agents
- godot_rl_agents custom env tutorial: https://github.com/edbeeching/godot_rl_agents/blob/main/docs/CUSTOM_ENV.md
- Cat's Souls-like Template (reference): https://github.com/catprisbrey/Cats-Godot4-Modular-Souls-like-Template