extends "res://scripts/characterComponents/character.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var puppet_pos = Vector2()
var puppet_motion = Vector2()

puppet func set_puppet_physics(pos, mot):
	puppet_pos = pos
	puppet_motion = mot

func _physics_process(_delta):
	var motion = Vector2()

	if is_network_master():
		if Input.is_action_pressed("move_left"):
			motion += Vector2(-1, 0)
		if Input.is_action_pressed("move_right"):
			motion += Vector2(1, 0)
		if Input.is_action_pressed("move_up"):
			motion += Vector2(0, -1)
		if Input.is_action_pressed("move_down"):
			motion += Vector2(0, 1)
		
		if Input.is_action_pressed("attack"):
			$WeaponAnimations.play("attack")
		
		rpc_unreliable('set_puppet_physics', position, motion)
	else:
		position = puppet_pos
		motion = puppet_motion

	# FIXME: Use move_and_slide
	move_and_slide(motion * moveSpeed)
	if not is_network_master():
		puppet_pos = position # To avoid jitter
		
	if(motion.x!=0 or motion.y!=0):
		if(motion.x>0):
			$playerSprite.scale.x=1
		elif(motion.x<0):
			$playerSprite.scale.x=-1
			
func set_player_name(new_name):
	print("set name "+new_name)


func _ready():
	if is_network_master():
		get_node("camera").current=true
	puppet_pos = position


