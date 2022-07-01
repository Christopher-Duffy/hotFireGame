extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func body_entered(body):
	player = body
	print('slime found the player')
	
func body_exited(body):
	player = null
	print('slime lost the player')
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
