extends PossessableCreature
class_name WormCreature

@export var dig_speed := 100
@export var dig_turn_speed := 2
@export var dig_end_boost := 100
@export var destroy_end_boost :=150
@export var can_dig_down := false

var burrowing := false
var started_burrowing_this_frame := false
var heading := Vector2.DOWN

@onready var dirt_raycast_top_left := $DirtDetectorUpLeft as RayCast2D
@onready var dirt_raycast_top_right := $DirtDetectorUpRight as RayCast2D
@onready var dirt_raycast_bottom_left := $DirtDetectorDownLeft as RayCast2D
@onready var dirt_raycast_bottom_right := $DirtDetectorDownRight as RayCast2D
@onready var dirt_raycast_down := $DirtDetectorDown as RayCast2D

@onready var walk_collision := $CollisionShape2D as CollisionShape2D
@onready var dirt_check_area := $DirtCheckArea as Area2D

func check_jump():
	pass

func _physics_process(delta: float) -> void:
	if(burrowing):
		physics_collisions = dirt_check_area.get_overlapping_bodies()
	super._physics_process(delta)

func check_primary_action() -> void:
	if(burrowing || !Input.is_action_just_pressed("primary_ability")):
		return
	var tilemap
	if dirt_raycast_top_left.is_colliding() && dirt_raycast_bottom_left.is_colliding() && velocity.x < 0:
		print("left burrow")
		tilemap = dirt_raycast_top_left.get_collider()
		var upper_tile = tilemap.local_to_map(dirt_raycast_top_left.get_collision_point() + Vector2.LEFT)
		var lower_tile = tilemap.local_to_map(dirt_raycast_bottom_left.get_collision_point() + Vector2.LEFT)
		
		var new_pos = destroy_blocks_double(tilemap, upper_tile, lower_tile, position, TileSet.CellNeighbor.CELL_NEIGHBOR_LEFT_SIDE)
		if(new_pos != position):
			position = new_pos
			velocity = Vector2.LEFT * destroy_end_boost
			alive = false
	elif dirt_raycast_top_left.is_colliding() && velocity.x < 0:
		print ("top left burrow")
		tilemap = dirt_raycast_top_left.get_collider()
		var tile = tilemap.local_to_map(dirt_raycast_top_left.get_collision_point() + Vector2.LEFT)
		var new_pos = destroy_blocks(tilemap, tile, position, TileSet.CellNeighbor.CELL_NEIGHBOR_LEFT_SIDE)
		if(new_pos != position):
			position = new_pos
			velocity = Vector2.LEFT * destroy_end_boost
			alive = false
	elif dirt_raycast_bottom_left.is_colliding() && velocity.x < 0:
		print ("bottom left burrow")
		tilemap = dirt_raycast_top_left.get_collider()
		var tile = tilemap.local_to_map(dirt_raycast_bottom_left.get_collision_point() + Vector2.LEFT)
		var new_pos = destroy_blocks(tilemap, tile, position, TileSet.CellNeighbor.CELL_NEIGHBOR_LEFT_SIDE)
		if(new_pos != position):
			position = new_pos
			velocity = Vector2.LEFT * destroy_end_boost
			alive = false
	elif dirt_raycast_top_right.is_colliding() && dirt_raycast_bottom_right.is_colliding() && velocity.x > 0:
		print("right burrow")
		tilemap = dirt_raycast_top_right.get_collider()
		var upper_tile = tilemap.local_to_map(dirt_raycast_top_right.get_collision_point() + Vector2.LEFT)
		var lower_tile = tilemap.local_to_map(dirt_raycast_bottom_right.get_collision_point() + Vector2.LEFT)
		
		var new_pos = destroy_blocks_double(tilemap, upper_tile, lower_tile, position, TileSet.CellNeighbor.CELL_NEIGHBOR_RIGHT_SIDE)
		if(new_pos != position):
			position = new_pos
			velocity = Vector2.RIGHT * destroy_end_boost
			alive = false
	elif dirt_raycast_top_right.is_colliding() && velocity.x > 0:
		print("right burrow")
		tilemap = dirt_raycast_top_right.get_collider()
		var tile = tilemap.local_to_map(dirt_raycast_top_right.get_collision_point() + Vector2.RIGHT)
		var new_pos = destroy_blocks(tilemap, tile, position, TileSet.CellNeighbor.CELL_NEIGHBOR_RIGHT_SIDE)
		if(new_pos != position):
			position = new_pos
			velocity = Vector2.RIGHT * destroy_end_boost
			alive = false
	elif dirt_raycast_bottom_right.is_colliding() && velocity.x > 0:
		print("right burrow")
		tilemap = dirt_raycast_bottom_right.get_collider()
		var tile = tilemap.local_to_map(dirt_raycast_bottom_right.get_collision_point() + Vector2.RIGHT)
		var new_pos = destroy_blocks(tilemap, tile, position, TileSet.CellNeighbor.CELL_NEIGHBOR_RIGHT_SIDE)
		if(new_pos != position):
			position = new_pos
			velocity = Vector2.RIGHT * destroy_end_boost
			alive = false
		
	elif dirt_raycast_down.is_colliding() && can_dig_down:
		print("down burrow")
		tilemap = dirt_raycast_down.get_collider()
		var tile = tilemap.local_to_map(dirt_raycast_down.get_collision_point() + Vector2.DOWN)
		var new_pos = destroy_blocks(tilemap, tile, position, TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_SIDE)
		if(new_pos != position):
			position = new_pos
			velocity = Vector2.DOWN * destroy_end_boost
			alive = false

func check_secondary_action() -> void:
	if(!burrowing && Input.is_action_just_pressed("secondary_ability")):
		print("secondary detected")
		if dirt_raycast_top_left.is_colliding() || dirt_raycast_bottom_left && velocity.x < 0:
			heading = Vector2.LEFT
			burrowing = true
			velocity = Vector2.LEFT * dig_speed
			print("left burrow")
		elif dirt_raycast_top_right.is_colliding() || dirt_raycast_bottom_right && velocity.x > 0:
			heading = Vector2.RIGHT
			burrowing = true
			velocity = Vector2.RIGHT * dig_speed
			print("right burrow")
		elif dirt_raycast_down.is_colliding():
			heading = Vector2.DOWN
			burrowing = true
			velocity = Vector2.DOWN * dig_speed
			print("down burrow")
		
		if(burrowing):
			print(collision_mask)
			started_burrowing_this_frame = true
			set_collision_mask_value(1,false);
			print("start burrowing ", collision_mask)
			##walk_collision.disabled = true

func check_unpossess():
	if(!burrowing):
		super.check_unpossess()

func check_move():
	if(burrowing):
		if(started_burrowing_this_frame):
			started_burrowing_this_frame = false
		elif(physics_collisions.size() == 0):
			print("ending ", physics_collisions)
			burrowing = false
			velocity = dig_end_boost * heading
			set_collision_mask_value(1,true);
			return
		
		var lastCollision = get_last_slide_collision() 
		
		if(lastCollision !=  null):
			heading = heading.bounce(lastCollision.get_normal())
		
		var turn = Input.get_axis("move_left", "move_right")
		if(turn < 0):
			heading = heading.rotated(deg_to_rad(-dig_turn_speed))
		elif(turn > 0):
			heading = heading.rotated(deg_to_rad(dig_turn_speed))
		velocity = heading * dig_speed
	
	elif(is_on_floor()):
		super.check_move()

func destroy_blocks( tilemap: TileMapLayer,  starting_tile_pos: Vector2i, real_pos: Vector2, direction: TileSet.CellNeighbor) -> Vector2:
	var tile_data: TileData = tilemap.get_cell_tile_data(starting_tile_pos)
	print("destroy blocks ", tile_data)
	if(tile_data == null):
		return real_pos
	if(tile_data.get_custom_data("Is_Dirt")):
		print("tile was dirt")
		var new_real_pos = tilemap.map_to_local(starting_tile_pos)
		new_real_pos = destroy_blocks(tilemap, tilemap.get_neighbor_cell(starting_tile_pos,direction), new_real_pos, direction)
		tilemap.set_cell(starting_tile_pos)
		return new_real_pos
	else:
		print("tile wasn't dirt")
		return real_pos
	

func destroy_blocks_double( tilemap: TileMapLayer,  upper_tile_pos: Vector2i, lower_tile_pos: Vector2i, real_pos: Vector2, direction: TileSet.CellNeighbor) -> Vector2:
	var upper_tile_data: TileData = tilemap.get_cell_tile_data(upper_tile_pos)
	var lower_tile_data: TileData = tilemap.get_cell_tile_data(lower_tile_pos)
	#print("destroy blocks ", tile_data)
	if(upper_tile_data == null || lower_tile_data == null):
		return real_pos
	
	var upper_dirt = upper_tile_data.get_custom_data("Is_Dirt")
	var lower_dirt = lower_tile_data.get_custom_data("Is_Dirt")
	if(upper_tile_data.get_custom_data("Block_Worm") || lower_tile_data.get_custom_data("Block_Worm")):
		return real_pos
	elif(upper_dirt || lower_dirt):
		print("atile was dirt")
		var new_real_pos = (tilemap.map_to_local(upper_tile_pos) + tilemap.map_to_local(lower_tile_pos)) / 2
		new_real_pos = destroy_blocks_double(tilemap, tilemap.get_neighbor_cell(upper_tile_pos,direction), tilemap.get_neighbor_cell(lower_tile_pos,direction), new_real_pos, direction)
		if(upper_dirt):
			tilemap.set_cell(upper_tile_pos)
		if(lower_dirt):
			tilemap.set_cell(lower_tile_pos)
		return new_real_pos
	else:
		print("tile wasn't dirt")
		return real_pos
	
