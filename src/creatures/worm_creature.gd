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
var dirt_tile_map: TileMapLayer
var stone_tile_map: TileMapLayer

@onready var dirt_raycast_top_left := $DirtDetectorUpLeft as RayCast2D
@onready var dirt_raycast_top_right := $DirtDetectorUpRight as RayCast2D
@onready var dirt_raycast_bottom_left := $DirtDetectorDownLeft as RayCast2D
@onready var dirt_raycast_bottom_right := $DirtDetectorDownRight as RayCast2D
@onready var dirt_raycast_down := $DirtDetectorDown as RayCast2D

@onready var walk_collision := $CollisionShape2D as CollisionShape2D
@onready var dirt_check_area := $DirtCheckArea as Area2D

func check_jump():
	pass

func _ready() -> void:
	dirt_tile_map = get_parent()._dirt_tilemap
	stone_tile_map = get_parent()._stone_tilemap

func _physics_process(delta: float) -> void:
	if(burrowing):
		physics_collisions = dirt_check_area.get_overlapping_bodies()
	super._physics_process(delta)

func check_primary_action() -> void:
	if(burrowing || !Input.is_action_just_pressed("primary_ability") || !alive):
		return
	if dirt_raycast_top_left.is_colliding() && dirt_raycast_bottom_left.is_colliding() && velocity.x < 0:
		print("left double burrow")
		var upper_tile = dirt_tile_map.local_to_map(dirt_raycast_top_left.get_collision_point() + Vector2.LEFT)
		var lower_tile = dirt_tile_map.local_to_map(dirt_raycast_bottom_left.get_collision_point() + Vector2.LEFT)
		var new_pos
		if(upper_tile == lower_tile):
			print("upper and lower the same")
			new_pos = destroy_blocks_double(dirt_tile_map.get_neighbor_cell(upper_tile, TileSet.CELL_NEIGHBOR_TOP_SIDE), upper_tile, Vector2(position), TileSet.CellNeighbor.CELL_NEIGHBOR_LEFT_SIDE)
		else:
			new_pos = destroy_blocks_double(upper_tile, lower_tile, Vector2(position), TileSet.CellNeighbor.CELL_NEIGHBOR_LEFT_SIDE)
			
		if(new_pos != position):
			position.x = new_pos.x
			velocity = Vector2.LEFT * destroy_end_boost
			alive = false
	elif dirt_raycast_top_left.is_colliding() && velocity.x < 0:
		print ("top left burrow")
		var tile = dirt_tile_map.local_to_map(dirt_raycast_top_left.get_collision_point() + Vector2.LEFT)
		var new_pos = destroy_blocks_double(tile, dirt_tile_map.get_neighbor_cell(tile,TileSet.CELL_NEIGHBOR_BOTTOM_SIDE), Vector2(position), TileSet.CellNeighbor.CELL_NEIGHBOR_LEFT_SIDE)
		if(new_pos != position):
			position.x = new_pos.x
			velocity = Vector2.LEFT * destroy_end_boost
			alive = false
	elif dirt_raycast_bottom_left.is_colliding() && velocity.x < 0:
		print ("bottom left burrow")
		var tile = dirt_tile_map.local_to_map(dirt_raycast_bottom_left.get_collision_point() + Vector2.LEFT)
		var new_pos = destroy_blocks_double(dirt_tile_map.get_neighbor_cell(tile,TileSet.CELL_NEIGHBOR_TOP_SIDE), tile, Vector2(position), TileSet.CellNeighbor.CELL_NEIGHBOR_LEFT_SIDE)
		if(new_pos != position):
			position.x = new_pos.x
			velocity = Vector2.LEFT * destroy_end_boost
			alive = false
	elif dirt_raycast_top_right.is_colliding() && dirt_raycast_bottom_right.is_colliding() && velocity.x > 0:
		print("right double burrow")
		var upper_tile = dirt_tile_map.local_to_map(dirt_raycast_top_right.get_collision_point() + Vector2.RIGHT)
		var lower_tile = dirt_tile_map.local_to_map(dirt_raycast_bottom_right.get_collision_point() + Vector2.RIGHT)
		var new_pos
		if(upper_tile == lower_tile):
			print("same top and bottom")
			new_pos = destroy_blocks_double(dirt_tile_map.get_neighbor_cell(upper_tile, TileSet.CELL_NEIGHBOR_TOP_SIDE), upper_tile, Vector2(position), TileSet.CellNeighbor.CELL_NEIGHBOR_RIGHT_SIDE)
		else:
			new_pos = destroy_blocks_double(upper_tile, lower_tile, Vector2(position), TileSet.CellNeighbor.CELL_NEIGHBOR_RIGHT_SIDE)
		if(new_pos != position):
			position.x = new_pos.x
			velocity = Vector2.RIGHT * destroy_end_boost
			alive = false
	elif dirt_raycast_top_right.is_colliding() && velocity.x > 0:
		print("top right burrow")
		var tile = dirt_tile_map.local_to_map(dirt_raycast_top_right.get_collision_point() + Vector2.RIGHT)
		var new_pos = destroy_blocks_double(tile, dirt_tile_map.get_neighbor_cell(tile,TileSet.CELL_NEIGHBOR_BOTTOM_SIDE), Vector2(position), TileSet.CellNeighbor.CELL_NEIGHBOR_RIGHT_SIDE)
		if(new_pos != position):
			position.x = new_pos.x
			velocity = Vector2.RIGHT * destroy_end_boost
			alive = false
	elif dirt_raycast_bottom_right.is_colliding() && velocity.x > 0:
		print("bottom right burrow")
		var tile = dirt_tile_map.local_to_map(dirt_raycast_bottom_right.get_collision_point() + Vector2.RIGHT)
		var new_pos = destroy_blocks_double(dirt_tile_map.get_neighbor_cell(tile,TileSet.CELL_NEIGHBOR_TOP_SIDE), tile, Vector2(position), TileSet.CellNeighbor.CELL_NEIGHBOR_RIGHT_SIDE)
		if(new_pos != position):
			position.x = new_pos.x
			velocity = Vector2.RIGHT * destroy_end_boost
			alive = false
		
	elif dirt_raycast_down.is_colliding() && can_dig_down:
		print("down burrow")
		var tile = dirt_tile_map.local_to_map(dirt_raycast_down.get_collision_point() + Vector2.DOWN)
		var new_pos = destroy_blocks(dirt_tile_map, tile, Vector2(position), TileSet.CellNeighbor.CELL_NEIGHBOR_BOTTOM_SIDE)
		if(new_pos != position):
			position.x = new_pos.x
			velocity = Vector2.DOWN * destroy_end_boost
			alive = false

func check_secondary_action() -> void:
	if(!burrowing && Input.is_action_just_pressed("secondary_ability") && alive):
		print("secondary detected")
		if (dirt_raycast_top_left.is_colliding() || dirt_raycast_bottom_left.is_colliding()) && velocity.x < 0:
			heading = Vector2.LEFT
			burrowing = true
			velocity = Vector2.LEFT * dig_speed
			print("left burrow")
		elif (dirt_raycast_top_right.is_colliding() || dirt_raycast_bottom_right.is_colliding()) && velocity.x > 0:
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
		var block = check_special_block_raycast(tilemap.map_to_local(starting_tile_pos))
		print(block)
		if(block == null || !block.is_diggable):
			print("tile wasn't dirt")
			return real_pos
		print("tile was dirt")
		var new_real_pos = tilemap.map_to_local(starting_tile_pos)
		new_real_pos = destroy_blocks(tilemap, tilemap.get_neighbor_cell(starting_tile_pos,direction), new_real_pos, direction)
		tilemap.set_cell(starting_tile_pos)
		return new_real_pos
	elif(tile_data.get_custom_data("Is_Dirt")):
		print("tile was dirt")
		var new_real_pos = tilemap.map_to_local(starting_tile_pos)
		new_real_pos = destroy_blocks(tilemap, tilemap.get_neighbor_cell(starting_tile_pos,direction), new_real_pos, direction)
		tilemap.set_cell(starting_tile_pos)
		return new_real_pos
	else:
		print("tile wasn't dirt")
		return real_pos

func destroy_blocks_double( upper_tile_pos: Vector2i, lower_tile_pos: Vector2i, real_pos: Vector2, direction: TileSet.CellNeighbor) -> Vector2:
	var upper_dirt_tile_data: TileData = dirt_tile_map.get_cell_tile_data(upper_tile_pos)
	var lower_dirt_tile_data: TileData = dirt_tile_map.get_cell_tile_data(lower_tile_pos)
	var upper_stone_tile_data: TileData = stone_tile_map.get_cell_tile_data((upper_tile_pos))
	var lower_stone_tile_data: TileData = stone_tile_map.get_cell_tile_data(lower_tile_pos)
	var upper_block: Block
	var lower_block: Block
	print("destroy blocks double ", upper_dirt_tile_data, " ", upper_stone_tile_data, " ", upper_block, " ", lower_block)
	if(upper_dirt_tile_data == null && upper_stone_tile_data == null):
		upper_block = check_special_block_raycast(dirt_tile_map.map_to_local(upper_tile_pos))
		print("upper tile special: ", upper_block)
	if(lower_dirt_tile_data == null && lower_stone_tile_data == null):
		lower_block = check_special_block_raycast(dirt_tile_map.map_to_local(lower_tile_pos))
		print("lower tile special: ", lower_block)
	var upper_dirt
	if(upper_dirt_tile_data):
		upper_dirt = upper_dirt_tile_data.get_custom_data("Is_Dirt")
		print("upper tile data check: ",  upper_dirt)
	var lower_dirt
	if(lower_dirt_tile_data):
		lower_dirt = lower_dirt_tile_data.get_custom_data("Is_Dirt")
		print("lower tile data check: ", lower_dirt)
	if((upper_stone_tile_data != null) || (lower_stone_tile_data != null) || (upper_block != null && !upper_block.is_diggable) || (lower_block != null && !lower_block.is_diggable)):
		print("not diggable")
		return real_pos
	elif(upper_dirt || lower_dirt || (upper_block != null && upper_block.is_diggable) || (lower_block != null && lower_block.is_diggable)):
		print("a tile was dirt")
		var new_real_pos = Vector2(dirt_tile_map.map_to_local(lower_tile_pos).x, real_pos.y)
		new_real_pos = destroy_blocks_double(dirt_tile_map.get_neighbor_cell(upper_tile_pos,direction), dirt_tile_map.get_neighbor_cell(lower_tile_pos,direction), new_real_pos, direction)
		if(upper_dirt):
			dirt_tile_map.set_cell(upper_tile_pos)
		if(lower_dirt):
			dirt_tile_map.set_cell(lower_tile_pos)
		if(upper_block != null):
			upper_block.disable()
			upper_block.queue_free()
		if(lower_block != null):
			lower_block.disable()
			lower_block.queue_free()
		return new_real_pos
	else:
		print("tile wasn't dirt")
		return real_pos

func get_tilemap(raycast: RayCast2D) -> TileMapLayer:
	var collider = raycast.get_collider()
	if(collider == null):
		return null
	if(collider is TileMapLayer):
		return collider
	else:
		return collider.get_parent()

func check_special_block_raycast(block_pos) -> Block:
	print("special blocks")
	var space_state = get_world_2d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters2D.create(block_pos, block_pos + Vector2.UP, pow(2,0) + pow(2,4))
	query.hit_from_inside = true
	query.collision_mask
	var result = space_state.intersect_ray(query)
	print("query result ", result)
	if(result && result.collider is Block):
		return result.collider as Block
	return null
