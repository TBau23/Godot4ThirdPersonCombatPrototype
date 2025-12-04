class_name TrainingArena
extends Node3D

## Minimal training arena for two-player combat testing
## Sets up required globals and spawns fighters

@export var player1: Player
@export var player2: Player
@export var camera_controller: TrainingCameraController
@export var lock_on_system: LockOnSystem
@export var backstab_system: BackstabSystem
@export var dizzy_system: DizzySystem
@export var void_death_system: VoidDeathSystem


func _enter_tree():
	# Register systems to globals (player.gd and components expect these)
	Globals.camera_controller = camera_controller
	Globals.lock_on_system = lock_on_system
	Globals.backstab_system = backstab_system
	Globals.dizzy_system = dizzy_system
	Globals.void_death_system = void_death_system
	# Set player1 as the "main" player for systems that need a reference
	# (lock_on, dizzy, backstab systems reference Globals.player)
	Globals.player = player1
	# Not setting checkpoint_system, music_system, user_interface (guarded in code)


func _ready():
	# Capture mouse for combat
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	print("Training Arena loaded!")
	print("Player 1 at: ", player1.global_position)
	print("Player 2 at: ", player2.global_position)
	print("Press ESC to release mouse")


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("ui_text_backspace"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
