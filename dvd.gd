extends Sprite2D

var fwX: bool = false;
var fwY: bool = false;
var speed: int = 100
var borderWidth: int = 0
var borderHeight: int = 0

func _ready():
	DisplayServer.window_set_current_screen(DisplayServer.get_primary_screen())
	%dvd.position = Vector2(DisplayServer.screen_get_size().x / 2, DisplayServer.screen_get_size().y / 2)
	borderWidth = %dvd.texture.get_width() / 2
	borderHeight = %dvd.texture.get_height() / 2
	
	fwX = randi_range(0, 1)
	fwY = randi_range(0, 1)
	
func _physics_process(delta):
	move(delta)
	
func calcFw():
	if %dvd.position.x <= borderWidth:
		fwX = true
		changeColor()
	
	if %dvd.position.y <= borderHeight:
		fwY = true
		changeColor()
		
	if %dvd.position.x >= DisplayServer.screen_get_size().x - borderWidth:
		fwX = false
		changeColor()
	
	if %dvd.position.y >= DisplayServer.screen_get_size().y - borderHeight:
		fwY = false
		changeColor()
		
func move(delta):
	calcFw()
	
	var vectorX = 0
	var vectorY = 0
		
	if fwX:
		vectorX += speed * delta
	else:
		vectorX -= speed * delta
	
	if fwY:
		vectorY += speed * delta
	else:
		vectorY -= speed * delta
		
	%dvd.position = Vector2(%dvd.position.x + vectorX, %dvd.position.y + vectorY)
	set_passthrough(%dvd)

#https://github.com/alinehui/partially-clickthrough-transparent
func set_passthrough(sprite):
	var texture_center: Vector2 = sprite.texture.get_size() / 2 # Center
	var texture_corners: PackedVector2Array = [
		sprite.global_position + texture_center * Vector2(-1, -1), # Top left corner
		sprite.global_position + texture_center * Vector2(1, -1), # Top right corner
		sprite.global_position + texture_center * Vector2(1 , 1), # Bottom right corner
		sprite.global_position + texture_center * Vector2(-1 ,1) # Bottom left corner
	]
  
	DisplayServer.window_set_mouse_passthrough(texture_corners)

func changeColor():
	modulate = Color(randf(), randf(), randf(), 1.0)
