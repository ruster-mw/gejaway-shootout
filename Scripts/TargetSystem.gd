class_name TargetSystem
extends Node2D

@export var range : float = 1600
@export var offset : Vector2


func getTargetPosition() -> Vector2:
	return to_global(offset)

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
