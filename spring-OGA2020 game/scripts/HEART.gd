extends Sprite

var heartTex = get_texture()
var heartImg = heartTex.get_data()
var heartPixelArray = heartImg.get_data()



var pxPenPos = Vector2(0,0)
var pxPenColor = Color(0,0,0,1) #black/invisible to start

var matrix = []
var heartColorArray = []

#var heartSizeH = heartTexture.

func _ready():
	#get pixel array
#	for ny in heartImg.get_height():
	
	
	
	
	for x in range(heartImg.get_width()):
		matrix.append([])
		heartColorArray.append([])
		
		for y in range(heartImg.get_height()):
			heartColorArray[x].append(0)
			matrix[x].append(0)
			heartImg.lock()
			matrix[x][y]=heartImg.get_pixel(x,y)
			heartColorArray[x][y]
	
	heartColorArray = PoolColorArray(matrix)

func _changeColor(changePos: Vector2, newColor: Color):
	heartImg.unlock()
	heartImg.set_pixelv(changePos, newColor)
	

func updateHeart():
	pass
	
	
func _physics_process(delta):
	pass
