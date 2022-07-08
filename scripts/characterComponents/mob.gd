extends "res://scripts/characterComponents/character.gd"

var target = null

func _on_AwareBox_body_entered(body):
	target = body
	pass # Replace with function body.

func _on_AwareBox_body_exited(body):
	target = null
	pass # Replace with function body.

func _on_HurtBox_area_entered(area):
	print(area.name)
	if (area.name == "playerWeaponHit"):
		rpc("killSelf")

func _physics_process(delta):
	if(target!=null):
		#a simple straight line follow
		var direction = Vector2()
		direction += (target.position - self.position).normalized()
		move_and_slide(direction*moveSpeed)
		
		if is_network_master():
			rpc_unreliable('puppet_position', self.position)

puppet func puppet_position(pos):
	position = pos
