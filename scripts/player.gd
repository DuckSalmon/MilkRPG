extends CharacterBody2D

const TILE_SIZE = 32

var direction: Vector2 = Vector2.ZERO
var pixels_per_second: set = _pixels_per_second_changed

var _step_size: float
func _pixels_per_second_changed(value: float) -> void:
	pixels_per_second = value
	_step_size = (1 / pixels_per_second)

# Accumulates delta, aka fractions of seconds, to time movement
var _step: float = 0
# Count movement in distinct integer steps
var _pixels_moved: int = 0 

func is_moving() -> bool:
	return self.direction.x != 0 or self.direction.y != 0

func _ready() -> void:
	self.pixels_per_second = 2 * TILE_SIZE

func _physics_process(delta: float) -> void:
	if not is_moving(): return
	# delta is measured in fractions of seconds, so for a speed of
	# 4 pixels_per_second, we need to accumulate _step until 
	# it reaches 0.25, and then we can move a pixel
	_step += delta
	if _step < _step_size: return

	# Move a pixel
	_step -= _step_size
	_pixels_moved += 1
	move_and_collide(direction)

	# Complete movement
	if _pixels_moved >= TILE_SIZE:
		direction = Vector2.ZERO
		_pixels_moved = 0
		_step = 0

func _input(event: InputEvent) -> void:
	if is_moving(): return
	if Input.is_action_pressed("ui_right"):
		direction = Vector2(1, 0)
	elif Input.is_action_pressed("ui_left"):
		direction = Vector2(-1, 0)
	elif Input.is_action_pressed("ui_down"):
		direction = Vector2(0, 1)
	elif Input.is_action_pressed("ui_up"):
		direction = Vector2(0, -1)
