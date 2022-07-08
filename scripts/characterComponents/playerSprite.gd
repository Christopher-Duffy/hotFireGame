extends Node2D

var weaponDict = {
	"sword": preload("res://images/weapons/mainHand/sword.png"),
	"axe": preload("res://images/weapons/mainHand/axe.png"),
	"club": preload("res://images/weapons/mainHand/club.png"),
	"longsword": preload("res://images/weapons/mainHand/longsword.png"),
	"magicWand":preload("res://images/weapons/mainHand/magicWand.png"),

	"buster": preload("res://images/weapons/2hand/buster.png"),
	"demonicBuster": preload("res://images/weapons/2hand/demonicBuster.png"),
	"goldenBuster": preload("res://images/weapons/2hand/goldenBuster.png"),
	"greataxe": preload("res://images/weapons/2hand/greataxe.png"),
	"greatclub": preload("res://images/weapons/2hand/gronkclub.png"),
	
	"buckler": preload("res://images/weapons/offHand/buckler.png"),
	"dagger": preload("res://images/weapons/offHand/dagger.png"),
	"holySymbol": preload("res://images/weapons/offHand/holySymbol.png"),
	"kiteShield": preload("res://images/weapons/offHand/kiteShield.png"),
	"voodooHead": preload("res://images/weapons/offHand/voodooHead.png"),
}

var hatDict={
	"hornedHelmet": preload("res://images/dude/hats/hornedHelmet.png"),
	"ninjaHood": preload("res://images/dude/hats/ninjaHood.png"),
	"plateHelm": preload("res://images/dude/hats/plateHelm.png"),
	"skullCap": preload("res://images/dude/hats/skullCap.png"),
	"wizardHat": preload("res://images/dude/hats/wizardHat.png"),
}

var colorDict ={
	"untinted": Color(1,1,1),
	"dark": Color(.2,.2,.2),
	"ruby": Color(.7,.1,.1),
	"emerald": Color(.1,.7,.1),
	"sapphire": Color(.1,.1,.7),
	"gold": Color(1,1,0),
}

onready var mainHandSprite = get_node("MainHand")
onready var baseSprite = get_node("Base")
onready var shirtSprite = get_node("Shirt")
onready var skinSprite = get_node("Skin")
onready var armorSprite = get_node("Armor")
onready var hatSprite = get_node("Hat")
onready var offHandSprite = get_node("OffHand")
onready var twoHandSprite = get_node("2Hand")

var armorType="vest"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func setTwoHandSprite(imgName):
	mainHandSprite.visible = false
	offHandSprite.visible = false
	twoHandSprite.visible = true
	twoHandSprite.set_texture(weaponDict[imgName])
	
func setMainHandSprite(imgName):
	twoHandSprite.visible = false
	mainHandSprite.visible = true
	mainHandSprite.set_texture(weaponDict[imgName])
	
func setOffHandSprite(imgName):
	twoHandSprite.visible = false
	offHandSprite.visible = true
	offHandSprite.set_texture(weaponDict[imgName])
	
func setHatSprite(imgName, color):
	hatSprite.set_texture(hatDict[imgName])
	hatSprite.modulate = colorDict[color]

func setArmorSprite(type,color):
	armorType = type
	armorSprite.animation = "idle_"+armorType
	armorSprite.modulate = colorDict[color]
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
