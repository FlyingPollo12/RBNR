extends RigidBody2D


var firingCannonPos
var targetTilePos
export var speed : float


func init(cannonPos:Vector2, targetPos:Vector2):
	firingCannonPos = cannonPos
	targetTilePos = targetPos



# Called when the node enters the scene tree for the first time.
func _ready():
	position = firingCannonPos
	var targetTile = get_parent().posToTile(targetTilePos)
	#print("target tile: (" + str(targetTile.x) + "," + str(targetTile.y) + ")")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_position(get_position() + (position.direction_to(targetTilePos))*delta*speed)
	var curPos = get_parent().posToTile(get_position())
	#print("Current Tile: (" + str(curPos.x) + "," + str(curPos.y) + ")")
	if get_parent().posToTile(position) == get_parent().posToTile(targetTilePos):
		queue_free()
