extends TileMap

var SIZE = 10

const FLOOR = 'floor'
const WALL = 'wall'
const ROOF = 'roof'
const T = 'T'
const B = 'B'
const L = 'L'
const R = 'R'
const TL = 'TL'
const TR = 'TR'
const BL = 'BL'
const BR = 'BR'

func getTileDict():
	var tiles = {}
	for id in tile_set.get_tiles_ids():
		var fullname = tile_set.tile_get_name(id)
		var namesplit = fullname.split(' ')
		var weight = 10
		var tilename = '(blank)'
		if len(namesplit) > 1:
			tilename = namesplit[1]
		if len(namesplit) > 2:
			weight = int(namesplit[2])
		var tile = {
			id = id,
			fullname = fullname,
			type = namesplit[0],
			name = tilename,
			weight = weight
		}
		if not tile.type in tiles:
			tiles[tile.type] = []
		for i in range(weight):
			tiles[tile.type].append(tile)
	return tiles

onready var TILES = getTileDict()

func getTile(type, pos=null):
	if pos != null:
		type += '-' + pos
	if type in TILES:
		var i = rng.randi_range(0, len(TILES[type])-1)
		return TILES[type][i].id
	else:
		return TILES[ROOF][0].id

var rng = RandomNumberGenerator.new()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
class PathNode:
	var x = 0;
	var y = 0;
	var visited = false
	var north = true
	var south = true
	var east = true
	var west = true
	var northNode = null
	var southNode=null
	var westNode=null
	var eastNode=null
	var fromCell = null
	func to_dict():
		return {
			x = x,
			y = y,
			north = north,
			south = south,
			east = east,
			west = west
		}

func dictToPathNode(d):
	var p = PathNode.new()
	p.x = d.x
	p.y = d.y
	p.north = d.north
	p.south = d.south
	p.east = d.east
	p.west = d.west
	return p

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func makePath(x,y):
	var cells = x*y
	var matrix=[]
	for i in range(x):
		matrix.append([])
		matrix[i]=[]
		for j in range(y):
			matrix[i].append([])
			matrix[i][j] = PathNode.new()
			matrix[i][j].x=i
			matrix[i][j].y=j
	#actually do the depth first search
	var cell = matrix[0][0]
	matrix[0][0].visited = true
	cells-=1
	while (cells>0):
		var neighbors = []
		
		if(cell.x-1>=0 && matrix[cell.x-1][cell.y].visited == false):
			neighbors.append(matrix[cell.x-1][cell.y])
		
		if(cell.x<matrix.size()-1 && matrix[cell.x+1][cell.y].visited == false):
			neighbors.append(matrix[cell.x+1][cell.y])
		
		if(cell.y-1>=0 && matrix[cell.x][cell.y-1].visited == false):
			neighbors.append(matrix[cell.x][cell.y-1])
		
		if(cell.y< matrix[cell.x].size()-1 && matrix[cell.x][cell.y+1].visited == false):
			neighbors.append(matrix[cell.x][cell.y+1])
		
		if neighbors.size()==0:
			cell= cell.fromCell
		else:
			var nextCell = neighbors[rng.randi_range(0,neighbors.size()-1)]
			cells-=1
			nextCell.fromCell = cell
			nextCell.visited = true
			
			if (nextCell.x>cell.x):
				cell.east = false
				nextCell.west = false
			elif(nextCell.x<cell.x):
				cell.west = false
				nextCell.east = false
			elif(nextCell.y>cell.y):
				cell.south = false
				nextCell.north = false
			else:
				cell.north = false
				nextCell.south = false
				
			matrix[cell.x][cell.y] = cell
			matrix[nextCell.x][nextCell.y] = nextCell
			cell = nextCell
	return matrix

func makeChunk(pathNode):
	var x = pathNode.x
	var y = pathNode.y
	for i in range( (x*SIZE) , ((x+1)*SIZE) ):
		for j in range( (y*SIZE) , ((y+1)*SIZE) ):
			set_cell(i,j,getTile(FLOOR))
		
	if pathNode.south:
		for i in range( (x*SIZE) , ((x+1)*SIZE) ):
			set_cell(i,(y+1)*SIZE-2,getTile(ROOF,T))
			set_cell(i,(y+1)*SIZE-1,getTile(ROOF,B))
	
	if pathNode.north:
		for i in range( (x*SIZE) , ((x+1)*SIZE) ):
			set_cell(i,(y)*SIZE,getTile(WALL,T))
			set_cell(i,(y)*SIZE+1,getTile(WALL,B))

	if pathNode.east:
		for i in range( (y*SIZE) , ((y+1)*SIZE)):
			set_cell(((x+1)*SIZE)-1,i,getTile(ROOF,L))

	if pathNode.west:
		for i in range( (y*SIZE) , ((y+1)*SIZE)):
			set_cell((x)*SIZE,i,getTile(ROOF,R))
	
	# pillars
	if !pathNode.north and !pathNode.west:
		set_cell(x*SIZE,y*SIZE,getTile(WALL,TR))
		set_cell(x*SIZE,y*SIZE+1,getTile(WALL,BR))
	if !pathNode.north and !pathNode.east:
		set_cell((x+1)*SIZE-1,y*SIZE,getTile(WALL,TL))
		set_cell((x+1)*SIZE-1,y*SIZE+1,getTile(WALL,BL))
	
	if !pathNode.south and !pathNode.west:
		set_cell(x*SIZE,(y+1)*SIZE-2,getTile(ROOF,TR))
		set_cell(x*SIZE,(y+1)*SIZE-1,getTile(ROOF,R))
	if !pathNode.south and !pathNode.east:
		set_cell((x+1)*SIZE-1,(y+1)*SIZE-2,getTile(ROOF,TL))
		set_cell((x+1)*SIZE-1,(y+1)*SIZE-1,getTile(ROOF,L))
	
	# concave corners
	if pathNode.south and pathNode.west:
		set_cell(x*SIZE,(y+1)*SIZE-2,getTile(ROOF,BL))
		set_cell(x*SIZE,(y+1)*SIZE-1,getTile(ROOF))
	if pathNode.south and pathNode.east:
		set_cell((x+1)*SIZE-1,(y+1)*SIZE-2,getTile(ROOF,BR))
		set_cell((x+1)*SIZE-1,(y+1)*SIZE-1,getTile(ROOF))
	
func makeMapFromPath(pathNodes):
	for row in pathNodes:
		for node in row:
			makeChunk(node)

func setNeighbors (pathNodes):
	for i in range(1,pathNodes.size()-1):
		for j in range(1,pathNodes[i].size()-1):
			pathNodes[i][j].northNode=pathNodes[i][j-1]
			pathNodes[i][j].southNode=pathNodes[i][j+1]
			pathNodes[i][j].eastNode=pathNodes[i-1][j]
			pathNodes[i][j].westNode=pathNodes[i+1][j-1]
	return pathNodes

func makeRandom(width,height):
	rng.randomize()
	clear()
	var pathNodes = makePath(width,height)
	var serialized = []
	for i in pathNodes:
		var si = []
		serialized.append(si)
		for j in i:
			si.append(j.to_dict())
	pathNodes = setNeighbors(pathNodes)
	makeMapFromPath(pathNodes)
	return serialized

func makeFromPathNodes(width,height,pathNodes):
	for i in range(0,pathNodes.size()):
		for j in range(0,pathNodes[i].size()):
			pathNodes[i][j] = dictToPathNode(pathNodes[i][j])
	pathNodes = setNeighbors(pathNodes)
	makeMapFromPath(pathNodes)

