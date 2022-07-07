extends KinematicBody2D

signal health_updated(health)
signal killed()

const MOTION_SPEED = 90.0

var puppet_pos = Vector2()
var puppet_motion = Vector2()

var max_health=30
var health = max_health

onready var immunityTimer = $DamagedImmunity
onready var damageAnimations = $DamageAnimations

var rng = RandomNumberGenerator.new()

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
	move_and_slide(motion * MOTION_SPEED)
	if not is_network_master():
		puppet_pos = position # To avoid jitter

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if "min_damage" in collision.collider:
			damage(rng.randi_range(collision.collider.min_damage,collision.collider.max_damage))
	if(motion.x!=0 or motion.y!=0):
		if(motion.x>0):
			$spriteWrapper.scale.x=1
		elif(motion.x<0):
			$spriteWrapper.scale.x=-1
		$spriteWrapper/AnimatedSprite.animation = "run"
		#$WeaponAnimations.play("run")
	else:
		$spriteWrapper/AnimatedSprite.animation = "idle"
		#$WeaponAnimations.play("idle")

func set_player_name(new_name):
	get_node("label").set_text(new_name)


func _ready():
	if is_network_master():
		get_node("camera").current=true
	puppet_pos = position
	rng.randomize()

func damage(amount):
	
	if immunityTimer.is_stopped():
		immunityTimer.start()
		_set_health(health-amount)
		print("player hit for "+str(amount)+" damage!")
		damageAnimations.play("Damaged")
		damageAnimations.play("Immune")
	
func kill():
	print("the player has been killed")
	emit_signal("killed")

func _set_health(value):
	var prev_health = health
	health = clamp(value,0,max_health)
	if health != prev_health:
		emit_signal("health_updated",health)
		if health==0:
			kill()


func _on_DamagedImmunity_timeout():
	print("timer done")
	damageAnimations.play("Rest")
