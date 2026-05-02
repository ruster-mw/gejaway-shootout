extends Camera2D

@export var move_speed: float = 5.0  # How fast the camera catches up
@export var zoom_speed: float = 5.0  # How fast the zoom changes
@export var min_zoom: float = 0.5    # Smallest zoom level (zoomed out)
@export var max_zoom: float = 0.8    # Largest zoom level (zoomed in)
@export var margin: Vector2 = Vector2(200, 200) # Extra space around players

func _process(delta: float) -> void:
	var players = get_tree().get_nodes_in_group("players")
	if players.is_empty():
		print("nothing")
		return

	# 1. Calculate the bounding box of all players
	var rect = Rect2(players[0].global_position, Vector2.ZERO)

	for player in players:
	# merge() returns a new Rect2 that includes the new point
		rect = rect.merge(Rect2(player.global_position, Vector2.ZERO))
	
	# 2. Determine the Target Position (Center of the rect)
	var target_center = rect.get_center()
	
	# 3. Determine the Target Zoom
	# We compare the rect size + margin to the viewport size
	var screen_size = get_viewport_rect().size
	var width = rect.size.x + margin.x
	var height = rect.size.y + margin.y
	
	# We want the larger ratio to ensure everyone fits
	var zoom_factor = max(width / screen_size.x, height / screen_size.y)
	
	# In Godot, Camera2D zoom is a Vector2(x, y). 
	# 1.0 is default, higher numbers = zoomed out, lower = zoomed in.
	# We use 1/zoom_factor because if the box is 2x screen size, zoom should be 0.5.
	var target_zoom_val = clamp(1.0 / zoom_factor, min_zoom, max_zoom)
	var target_zoom = Vector2(target_zoom_val, target_zoom_val)

	# 4. Apply Smoothing (Lerp)
	global_position = global_position.lerp(target_center, move_speed * delta)
	zoom = zoom.lerp(target_zoom, zoom_speed * delta)
