extends Node2D

#---- Preloaded ----
var cannonBall = preload("res://Source/Levels/cannonBall.tscn")


#---- Turn Controller ----
const ECON_PHASE = 0
const BUILD_PHASE = 1
const PLANNING_PHASE = 2 
const CANNON_PHASE = 3
var PHASE #current phase var


#---- Tile id's ----
#ENVIRONMENT
const DESERT = 0
const PLAINS = 1
const WATER = 2
const MOUNTAIN = 3
const SPLIT = 4 #split water/plains
#STRUCTURES
const HORIZONTAL_WALL = 10
const VERTICAL_WALL = 12
const BR_WALL = 15
const BL_WALL = 14
const TR_WALL = 11
const TL_WALL = 9
const CANNON = 16
const CITY_RED = 5
const CITY_BLUE = 6
const CAPITAL_RED = 7
const CAPITAL_BLUE = 8
#UNITS
#...TBD


#---- Screen Constants ----
const SCALEX = 1 #scale of MainNode
const SCALEY = 1
var CELL_SIZE_X : int
var CELL_SIZE_Y : int 
const SIDEBAR_WIDTH = 80


#---- Grid Constraints ----
const GRID_MAXX = 15 #specific for this map


#---- Game var globals ----
var playerGold = 100
var myTimer



func _ready():
#setup
	screen_metrics()#prints all screen measurements
	
	# prepare timer. Use as:
	#   myTimer.start()
	#   yield(myTimer, "timeout")
	myTimer = Timer.new()
	myTimer.set_wait_time(2) # wait time can be set again at any point
	myTimer.set_one_shot(true)
	self.add_child(myTimer)
	
	
	#increase size.. THIS SHOULD BE UPDATED TO ACTUALLY FIT SCREEN!!!!
	scale = Vector2(SCALEX,SCALEY) #MainNode.scale : Vector2
	var tmp : Vector2 = $Environment.cell_size * SCALEX
	CELL_SIZE_X = tmp.x
	tmp = $Environment.cell_size * SCALEY
	CELL_SIZE_Y = tmp.y
	
	var cells = $Environment.get_used_cells()
	for cell in cells: #do something with each cell
		var index = $Environment.get_cell(cell.x, cell.y)
		#match index: #can match for any tileID (basically a switch but easier! :P)
		#	PLAINS:
		#		$Environment.set_cell(cell.x, cell.y, WATER)
	
	$notificationBox.hide()
	$econStat.text = "Econ: 0"
	PHASE = ECON_PHASE
	PhaseController()



func PhaseController():
#call function based on phase
	match PHASE:
		ECON_PHASE:
			$currentPhase.text = "Econ Phase"
			econ_phase()
		BUILD_PHASE:
			$currentPhase.text = "Build Phase"
			build_phase()
		#PLANNING_PHASE: for unit planning
		#planning_phase()
		CANNON_PHASE:
			$currentPhase.text = "Cannon Phase"
			cannon_phase()



func NextTurn():
	print("next turn func")
	match PHASE:
		ECON_PHASE:
			PHASE = BUILD_PHASE
		BUILD_PHASE:
			PHASE = CANNON_PHASE
		CANNON_PHASE:
			PHASE = ECON_PHASE
	PhaseController()



func econ_phase():
	print("econ phase")
	
	$notificationBox/phaseNotification.text = "Econ Phase\n" + str(playerGold) + " + 10"
	$notificationBox.show()
	myTimer.start()
	yield(myTimer, "timeout")
	$notificationBox.hide()
	playerGold = playerGold + 10
	NextTurn()



func build_phase():
	print("build phase")
	
	$notificationBox/phaseNotification.text = "Build Phase"
	$notificationBox.show()
	myTimer.start()
	yield(myTimer, "timeout")
	$notificationBox.hide()



func cannon_phase():
	print("cannon phase")
	
	# 2 cannons trace and point to cursor
	# 3 only cannons you control are selected
	
	# 1 clicking fires cannonball at tile selected
	
	# 4 destroy walls when hit



func _input(event):
# Handles all input.
# Filters input based on phase!
	if event is InputEventMouseButton:
		if event.is_pressed():
			var pos = event.position
			var x : int = pos.x - SIDEBAR_WIDTH
			var y : int = pos.y
		
			var newx = x / CELL_SIZE_X
			var newy = y / CELL_SIZE_Y
			var gridPos = Vector2(newx, newy)
			print(gridPos)
			if newx > GRID_MAXX:
				return
		
			#get cell at x,y and place wall
			if PHASE == BUILD_PHASE and playerGold > 4:
				$Structures.set_cell(newx, newy, HORIZONTAL_WALL)
				playerGold = playerGold - 5
			if PHASE == CANNON_PHASE:
				print("SHOOT")
				var cball = cannonBall.instance()
				cball.init(Vector2(32,176), Vector2(x,y))
				add_child(cball)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$econStat.text = "Econ: " + str(playerGold)



func screen_metrics():
	print("                 [Screen Metrics]")
	print("            Display size: ", OS.get_screen_size())
	print("   Decorated Window size: ", OS.get_real_window_size())
	print("             Window size: ", OS.get_window_size())
	print("        Project Settings: Width=", ProjectSettings.get_setting("display/window/size/width"), " Height=", ProjectSettings.get_setting("display/window/size/height")) 
	print(OS.get_window_size().x)
	print(OS.get_window_size().y)
