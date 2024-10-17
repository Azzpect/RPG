extends CharacterBody2D


var movement: Vector2
@export var lastDirection: Vector2 = Vector2.ZERO
@export var speed: int = 70
@onready var gameManager: Node = %gameManager
@onready var los: RayCast2D = %los
@onready var animation_tree: AnimationTree = $AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	if los.is_colliding():
		print(los.get_collider().name)
	if not gameManager.isSceneEnded:
		gameManager.emit_signal("_savePlayerData")


func _process(delta: float) -> void:
	if gameManager.isSceneEnded:
		return
	if movement[1] == 0:
		movement[0] = Input.get_axis("left", "right")
	if movement[0] == 0:
		movement[1] = Input.get_axis("up", "down")
	
	if movement != Vector2.ZERO:
		lastDirection = movement
	
	animation_tree.set("parameters/playerStates/playerIdle/blend_position", lastDirection)
	animation_tree.set("parameters/playerStates/playerWalk/blend_position", lastDirection)
	velocity = movement.normalized() * speed
	move_and_slide()

	#raycast
	los.target_position = lastDirection * 25
	los.force_raycast_update()
