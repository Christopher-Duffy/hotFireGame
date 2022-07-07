extends KinematicBody2D

const MOTION_SPEED = 60.0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player = null
var min_damage=5
var max_damage=8
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_body_entered(body):
	player = body
	
func _on_body_exited(body):
	player=null
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _physics_process(delta):
	if(player!=null):
		var motion = Vector2()
		motion += (player.position - self.position).normalized()
		move_and_slide(motion*MOTION_SPEED)
		if is_network_master():
			rpc_unreliable('puppet_position', self.position)

puppet func puppet_position(pos):
	position = pos


func _on_hurtbox_area_entered(area):
	if area.name=="SwordHitBox":
		rpc('kill_slime')

remotesync func kill_slime():
	print('slime die')
	queue_free()
