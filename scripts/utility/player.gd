extends CharacterBody2D


var movement: Vector2
var last_direction: Vector2 = Vector2.ZERO
@export var speed: int = 50

@onready var animation_tree: AnimationTree = $AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _process(delta: float) -> void:
	if movement[1] == 0:
		movement[0] = Input.get_axis("left", "right")
	if movement[0] == 0:
		movement[1] = Input.get_axis("up", "down")
	
	if movement != Vector2.ZERO:
		last_direction = movement
	
	animation_tree.set("parameters/playerStates/playerIdle/blend_position", last_direction)
	animation_tree.set("parameters/playerStates/playerWalk/blend_position", last_direction)
	velocity = movement.normalized() * speed
	move_and_slide()
