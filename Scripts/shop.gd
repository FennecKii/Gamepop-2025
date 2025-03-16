extends Sprite2D

@export var start_position: Vector2
@export var end_position: Vector2
@export var move_duration: float = 0.5

func _ready():
	# Start from the bottom
	position = start_position
	# Animate to the final position
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", end_position, move_duration).set_trans(Tween.TRANS_SINE)
