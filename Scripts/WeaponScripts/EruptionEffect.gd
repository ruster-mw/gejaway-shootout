extends Node2D

func _ready():
	$ExplosionParticles.emitting = true
	$FireParticles.emitting = true
	$ExplosionParticles.finished.connect(queue_free)
