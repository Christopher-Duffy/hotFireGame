extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("playerSprite").get_node("AnimationPlayer").play("idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_2hand_selected(index):
	match index:
		0:
			get_node("playerSprite").setTwoHandSprite("greatclub")
		1:
			get_node("playerSprite").setTwoHandSprite("buster")
		2:
			get_node("playerSprite").setTwoHandSprite("goldenBuster")
		3:
			get_node("playerSprite").setTwoHandSprite("demonicBuster")
		4:
			get_node("playerSprite").setTwoHandSprite("greataxe")


func _on_mainhand_item_selected(index):
	match index:
		0:
			get_node("playerSprite").setMainHandSprite("sword")
		1:
			get_node("playerSprite").setMainHandSprite("axe")
		2:
			get_node("playerSprite").setMainHandSprite("club")
		3:
			get_node("playerSprite").setMainHandSprite("longsword")
		4:
			get_node("playerSprite").setMainHandSprite("magicWand")


func _on_OptionButton_item_selected(index):
	match index:
		0:
			get_node("playerSprite").setOffHandSprite("buckler")
		1:
			get_node("playerSprite").setOffHandSprite("dagger")
		2:
			get_node("playerSprite").setOffHandSprite("holySymbol")
		3:
			get_node("playerSprite").setOffHandSprite("kiteShield")
		4:
			get_node("playerSprite").setOffHandSprite("voodooHead")


func _on_OptionButton2_item_selected(index):
		match index:
			0:
				get_node("playerSprite").setHatSpriteColor("untinted")
			1:
				get_node("playerSprite").setHatSpriteColor("dark")
			2:
				get_node("playerSprite").setHatSpriteColor("ruby")
			3:
				get_node("playerSprite").setHatSpriteColor("emerald")
			4:
				get_node("playerSprite").setHatSpriteColor("sapphire")
			5:
				get_node("playerSprite").setHatSpriteColor("gold")


func _on_OptionButton4_item_selected(index):
		match index:
			0:
				get_node("playerSprite").setArmorSpriteColor("untinted")
			1:
				get_node("playerSprite").setArmorSpriteColor("dark")
			2:
				get_node("playerSprite").setArmorSpriteColor("ruby")
			3:
				get_node("playerSprite").setArmorSpriteColor("emerald")
			4:
				get_node("playerSprite").setArmorSpriteColor("sapphire")
			5:
				get_node("playerSprite").setArmorSpriteColor("gold")


func _on_hatButton_item_selected(index):
	match index:
			0:
				get_node("playerSprite").setHatSprite("hornedHelmet")
			1:
				get_node("playerSprite").setHatSprite("ninjaHood")
			2:
				get_node("playerSprite").setHatSprite("plateHelm")
			3:
				get_node("playerSprite").setHatSprite("skullCap")
			4:
				get_node("playerSprite").setHatSprite("wizardHat")



func _on_armortype_item_selected(index):
	match index:
			0:
				get_node("playerSprite").setArmorSprite("chain")
			1:
				get_node("playerSprite").setArmorSprite("gi")
			2:
				get_node("playerSprite").setArmorSprite("plate")
			3:
				get_node("playerSprite").setArmorSprite("robe")
			4:
				get_node("playerSprite").setArmorSprite("vest")
