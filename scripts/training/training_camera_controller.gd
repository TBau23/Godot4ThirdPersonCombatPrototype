class_name TrainingCameraController
extends Node3D

## Minimal camera controller for training arena
## Provides the interface that other components expect from CameraController

@export var cam: Camera3D

var enabled: bool = true
var looking_around: bool = false


func reset() -> void:
	pass


func player_moving(_move_direction: Vector3, _running: bool, _delta: float) -> void:
	pass


func get_lock_on_position(target: Node3D) -> Vector2:
	if cam and target:
		return cam.unproject_position(target.global_position)
	return Vector2.ZERO
