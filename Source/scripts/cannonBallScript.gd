extends RigidBody2D


var firingCannonPos
var targetTilePos

func init(cannonPos, targetPos):
	firingCannonPos = cannonPos
	targetTilePos = targetPos

# Called when the node enters the scene tree for the first time.
func _ready():
	position = firingCannonPos
	apply_impulse(Vector2(100,-100), Vector2(10,10)) #this is not working how i thought it would..


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
