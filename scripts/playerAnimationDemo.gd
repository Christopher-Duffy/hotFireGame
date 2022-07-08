extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var thisPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_node("/root/world/Players").get_children())

	get_node("playerSprite").get_node("AnimationPlayer").play("idle")
	pass # Replace with function body.

var hatColor = "untinted"
var hat = "ninjaHood"

var armorColor = "untinted"
var armor = "gi"

var mainHand = "sword"
var offHand = "dagger"
var twoHand = "buster"
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_2hand_selected(index):
	match index:
		0:
			twoHand = "greatclub"
		1:
			twoHand = "buster"
		2:
			twoHand = "goldenBuster"
		3:
			twoHand = "demonicBuster"
		4:
			twoHand = "greataxe"
	gamestate.playerNode.setTwoHand(twoHand)


func _on_mainhand_item_selected(index):
	match index:
		0:
			mainHand = "sword"
		1:
			mainHand = "axe"
		2:
			mainHand = "club"
		3:
			mainHand = "longsword"
		4:
			mainHand = "magicWand"
	gamestate.playerNode.setMainHand(mainHand)


func _on_OptionButton_item_selected(index):
	match index:
		0:
			offHand = "buckler"
		1:
			offHand = "dagger"
		2:
			offHand = "holySymbol"
		3:
			offHand = "kiteShield"
		4:
			offHand = "voodooHead"
	gamestate.playerNode.setOffHand(offHand)

func _on_OptionButton2_item_selected(index):
	match index:
		0:
			hatColor="untinted"
		1:
			hatColor="dark"
		2:
			hatColor="ruby"
		3:
			hatColor="emerald"
		4:
			hatColor="sapphire"
		5:
			hatColor="gold"
	get_node("playerSprite").setHatSprite(hat,hatColor)
	gamestate.playerNode.setHat(hat,hatColor)


func _on_OptionButton4_item_selected(index):
	match index:
		0:
			armorColor="untinted"
		1:
			armorColor="dark"
		2:
			armorColor="ruby"
		3:
			armorColor="emerald"
		4:
			armorColor="sapphire"
		5:
			armorColor="gold"
	get_node("playerSprite").setArmorSprite(armor,armorColor)
	gamestate.playerNode.setArmor(armor,armorColor)


func _on_hatButton_item_selected(index):
	match index:
		0:
			hat="hornedHelmet"
		1:
			hat="ninjaHood"
		2:
			hat="plateHelm"
		3:
			hat="skullCap"
		4:
			hat="wizardHat"
	get_node("playerSprite").setHatSprite(hat,hatColor)
	gamestate.playerNode.setHat(hat,hatColor)


func _on_armortype_item_selected(index):
	match index:
		0:
			armor="chain"
		1:
			armor="gi"
		2:
			armor="plate"
		3:
			armor="robe"
		4:
			armor="vest"
	get_node("playerSprite").setArmorSprite(armor,armorColor)
	gamestate.playerNode.setArmor(armor,armorColor)


func _on_Button_pressed():
	self.visible = !self.visible
	pass # Replace with function body.
