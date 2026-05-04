extends Camera2D

@export var move_speed: float = 5.0  
@export var zoom_speed: float = 5.0  
@export var min_zoom: float = 0.1  
@export var max_zoom: float = 0.8   
@export var margin: Vector2 = Vector2(200, 200) 

func _process(delta: float) -> void:
	var players = get_tree().get_nodes_in_group("players")
	if players.is_empty():
		print("nothing")
		return
	var rect = Rect2(players[0].global_position, Vector2.ZERO)

	for player in players:
		rect = rect.merge(Rect2(player.global_position, Vector2.ZERO))
	var target_center = rect.get_center()
	var screen_size = get_viewport_rect().size
	var width = rect.size.x + margin.x
	var height = rect.size.y + margin.y
	var zoom_factor = max(width / screen_size.x, height / screen_size.y)
	var target_zoom_val = clamp(1.0 / zoom_factor, min_zoom, max_zoom)
	var target_zoom = Vector2(target_zoom_val, target_zoom_val)
	global_position = global_position.lerp(target_center, move_speed * delta)
	zoom = zoom.lerp(target_zoom, zoom_speed * delta)
