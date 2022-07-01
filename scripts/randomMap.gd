extends TileMap

var SIZE = 10

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
	var fromCell = null

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
			set_cell(i,j,0)
			
	if pathNode.north:
		for i in range( (x*SIZE) , ((x+1)*SIZE) ):
			set_cell(i,y*SIZE,1)
	if pathNode.south:
		for i in range( (x*SIZE) , ((x+1)*SIZE) ):
			set_cell(i,(y+1)*SIZE-1,1)
	if pathNode.west:
		for i in range( (y*SIZE) , ((y+1)*SIZE) ):
			set_cell(x*SIZE,i,1)
	if pathNode.east:
		for i in range( (y*SIZE) , ((y+1)*SIZE) ):
			set_cell((x+1)*SIZE-1,i,1)
	
func makeMapFromPath(pathNodes):
	for row in pathNodes:
		for node in row:
			makeChunk(node)

func makeRandom(width,height):
	rng.randomize()
	clear()
	var pathNodes = makePath(width,height)
	makeMapFromPath(pathNodes)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
