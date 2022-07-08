extends KinematicBody2D

export var moveSpeed:= 60.0

#character
	#type
	#size
	#stats
	#stateMachine	
	#kinematicBody
		#collisionBox
		#hurtBox
		#animation
		#weapon
			#hitbox
			#weaponAnimation	
	#character.takeDamage()
	#character.attack()
	#character.useAbility("name")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_HurtBox_area_entered(area):
	if (area.name == "SwordHitBox"):
		rpc("killSelf")
	pass # Replace with function body.
	
remotesync func killSelf():
	queue_free()
