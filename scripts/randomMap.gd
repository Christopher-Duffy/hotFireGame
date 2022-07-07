extends TileMap

var SIZE = 10

enum{
	floor1,
	wall1,
	pillartopleft1,
	pillartopright1,
	topwallleft1,
	topwallright1,
	pillarbottomleft1,
	pillarbottomright1,
	righttopwall1,
	lefttopwall1,
	topwall1,
	walltop1,
	wallfloor1,
	rightwallcorner1,
	leftwallcorner1,
	blackvoid
}

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
		return {'x': x, 'y': y, 'visited': visited, 'north': north, 'south': south, 'east': east, 'west': west}

func dictToPathNode(d):
	var p = PathNode.new()
	p.x = d['x']
	p.y = d['y']
	p.visited = d['visited']
	p.north = d['north']
	p.south = d['south']
	p.east = d['east']
	p.west = d['west']
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
			set_cell(i,j,floor1)

	if pathNode.east:
		for i in range( (y*SIZE) , ((y+1)*SIZE)):
			set_cell(((x+1)*SIZE)-2,i,topwallleft1)
			set_cell(((x+1)*SIZE)-1,i,topwallright1)
		
	if pathNode.south:
		for i in range( (x*SIZE) , ((x+1)*SIZE) ):
			set_cell(i,(y+1)*SIZE-2,walltop1)
			set_cell(i,(y+1)*SIZE-1,wallfloor1)
	
func makeMapFromPath(pathNodes):
	for row in pathNodes:
		for node in row:
			makeChunk(node)

func makeBorder(w,h):
	for i in range(w):
		set_cell(i,0,walltop1)
		set_cell(i,1,wall1)
		set_cell(i,2,wallfloor1)
		set_cell(i,h-2,topwall1)
		set_cell(i,h-1,-1)
	for i in range(h-2):
		set_cell(0,i,topwallright1)
		set_cell(w-1,i,topwallleft1)
	set_cell(0,h-2,rightwallcorner1)
	set_cell(w-1,h-2,leftwallcorner1)

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
	makeBorder(width*SIZE,height*SIZE)
	return serialized

func makeFromPathNodes(width,height,pathNodes):
	for i in range(0,pathNodes.size()):
		for j in range(0,pathNodes[i].size()):
			pathNodes[i][j] = dictToPathNode(pathNodes[i][j])
	pathNodes = setNeighbors(pathNodes)
	makeMapFromPath(pathNodes)
	makeBorder(width*SIZE,height*SIZE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
