extends Node2D


var firingCannonPos
var targetTilePos
var targetReached = false
var done = false
onready var myTimer = get_node("Timer")
var fireImage = load("res://Source/Textures/fire.png")

export var speed : float


func init(cannonPos:Vector2, targetPos:Vector2):
	firingCannonPos = cannonPos
	targetTilePos = targetPos



# Called when the node enters the scene tree for the first time.
func _ready():
	position = firingCannonPos
	var targetTile = get_parent().posToTile(targetTilePos)
	print("target tile: " + str(targetTile))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if done:
		return
	if targetReached:
		done = true
		myTimer.set_wait_time(1)
		myTimer.start()
		return
	
	var curpos = get_position()
	set_position(curpos + (curpos.direction_to(targetTilePos))*delta*speed)
	
	curpos = Vector2(curpos.x + 8, curpos.y + 8)#account for offset of sprite (needed for visuals to line up with tile map!)
	if ( get_parent().posToTile(curpos) == get_parent().posToTile(targetTilePos) ):
		targetReached = true
		$Sprite.set_texture(fireImage)
		set_position(targetTilePos)


func _timer_timeout():
	print("hit timeout")
	queue_free()
