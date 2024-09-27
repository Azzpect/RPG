extends CharacterBody2D


var movement: Vector2
var speed: int = 100

@onready var animation_tree: AnimationTree = $AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	movement = Input.get_vector("left", "right", "up", "down").normalized() * speed
	animation_tree.set("parameters/blend_position", movement)
	velocity = movement
	move_and_slide()
