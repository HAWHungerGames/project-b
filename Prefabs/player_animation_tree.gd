extends AnimationTree

@onready var settings: Node3D = GlobalPlayer.getPlayer()
@onready var state_machine_playback: AnimationNodeStateMachinePlayback = self.get("parameters/StateMachine/playback")
@onready var player_controller = $"../../.."
@onready var front_pointer = $"../../FrontPointer"

@onready var staminaCostPerDash = settings.staminaCostPerDash
@onready var maxStamina = settings.maxStamina

var rotation_front_pointer
var rel_vel
var rel_vel_xz
var dash_timer = 0
var max_dash_timer = 0.6
var dash_count = 0
var dash_count2 = 0
var dash = true
var is_sneaking = false

func _physics_process(delta: float) -> void:
	update_animation(delta)
	calc_dash()

func update_animation(delta):
	get_rel_vel()
	movement_animation()
	calc_dash_timer(delta)
	

func movement_animation():
	rotation_front_pointer = rotation_of_front_pointer()
	if Input.is_action_just_pressed("sneak") and !is_sneaking:
		is_sneaking = true
		state_machine_playback.travel("Sneaking")
	elif Input.is_action_just_pressed("dash") and dash and is_sneaking:
		if dash_count2 == 0:
			state_machine_playback.travel("Dashing3")
			
			if rotation_front_pointer <= 9 and rotation_front_pointer >= -9:
				self.set("parameters/StateMachine/Dashing3/blend_position", rel_vel_xz)
				
			elif rotation_front_pointer > 25 and rotation_front_pointer <= 31 or rotation_front_pointer < -25 and rotation_front_pointer >= -31:
				rel_vel_xz = Vector2(-rel_vel.x, -rel_vel.z)
				self.set("parameters/StateMachine/Dashing3/blend_position", rel_vel_xz)
				
			elif rotation_front_pointer > 9 and rotation_front_pointer <= 25:
				rel_vel_xz = Vector2(-rel_vel.z, rel_vel.x)
				self.set("parameters/StateMachine/Dashing3/blend_position", rel_vel_xz)
				
			elif rotation_front_pointer < -9 and rotation_front_pointer >= -25:
				rel_vel_xz = Vector2(rel_vel.z, -rel_vel.x)
				self.set("parameters/StateMachine/Dashing3/blend_position", rel_vel_xz)
				
			dash_timer = max_dash_timer
			dash_count2 = 1
				
		elif dash_count2 == 1:
			state_machine_playback.travel("Dashing4")
			
			if rotation_front_pointer <= 9 and rotation_front_pointer >= -9:
				self.set("parameters/StateMachine/Dashing4/blend_position", rel_vel_xz)
				
			elif rotation_front_pointer > 25 and rotation_front_pointer <= 31 or rotation_front_pointer < -25 and rotation_front_pointer >= -31:
				rel_vel_xz = Vector2(-rel_vel.x, -rel_vel.z)
				self.set("parameters/StateMachine/Dashing4/blend_position", rel_vel_xz)

			elif rotation_front_pointer > 9 and rotation_front_pointer <= 25:
				rel_vel_xz = Vector2(-rel_vel.z, rel_vel.x)
				self.set("parameters/StateMachine/Dashing4/blend_position", rel_vel_xz)

			elif rotation_front_pointer < -9 and rotation_front_pointer >= -25:
				rel_vel_xz = Vector2(rel_vel.z, -rel_vel.x)
				self.set("parameters/StateMachine/Dashing4/blend_position", rel_vel_xz)

			dash_timer = max_dash_timer
			dash_count2 = 0
				
	elif Input.is_action_just_pressed("sneak") and is_sneaking:
		is_sneaking = false
		state_machine_playback.travel("Walking")
	
	elif Input.is_action_just_pressed("dash") and dash and !is_sneaking:
		if dash_count == 0:
			state_machine_playback.travel("Dashing")
			
			if rotation_front_pointer <= 9 and rotation_front_pointer >= -9:
				self.set("parameters/StateMachine/Dashing/blend_position", rel_vel_xz)
					
			elif rotation_front_pointer > 25 and rotation_front_pointer <= 31 or rotation_front_pointer < -25 and rotation_front_pointer >= -31:
				rel_vel_xz = Vector2(-rel_vel.x, -rel_vel.z)
				self.set("parameters/StateMachine/Dashing/blend_position", rel_vel_xz)
					
			elif rotation_front_pointer > 9 and rotation_front_pointer <= 25:
				rel_vel_xz = Vector2(-rel_vel.z, rel_vel.x)
				self.set("parameters/StateMachine/Dashing/blend_position", rel_vel_xz)
					
			elif rotation_front_pointer < -9 and rotation_front_pointer >= -25:
				rel_vel_xz = Vector2(rel_vel.z, -rel_vel.x)
				self.set("parameters/StateMachine/Dashing/blend_position", rel_vel_xz)
					
			dash_timer = max_dash_timer
			dash_count = 1
				
		elif dash_count == 1:
			state_machine_playback.travel("Dashing2")
				
			if rotation_front_pointer <= 9 and rotation_front_pointer >= -9:
				self.set("parameters/StateMachine/Dashing2/blend_position", rel_vel_xz)
					
			elif rotation_front_pointer > 25 and rotation_front_pointer <= 31 or rotation_front_pointer < -25 and rotation_front_pointer >= -31:
				rel_vel_xz = Vector2(-rel_vel.x, -rel_vel.z)
				self.set("parameters/StateMachine/Dashing2/blend_position", rel_vel_xz)

			elif rotation_front_pointer > 9 and rotation_front_pointer <= 25:
				rel_vel_xz = Vector2(-rel_vel.z, rel_vel.x)
				self.set("parameters/StateMachine/Dashing2/blend_position", rel_vel_xz)

			elif rotation_front_pointer < -9 and rotation_front_pointer >= -25:
				rel_vel_xz = Vector2(rel_vel.z, -rel_vel.x)
				self.set("parameters/StateMachine/Dashing2/blend_position", rel_vel_xz)

			dash_timer = max_dash_timer
			dash_count = 0
	else:
		if dash_timer > 0:
			pass
		else:
			if !is_sneaking:
				state_machine_playback.travel("Walking")
				if rotation_front_pointer <= 9 and rotation_front_pointer >= -9:
					self.set("parameters/StateMachine/Walking/blend_position", rel_vel_xz)
				elif rotation_front_pointer > 25 and rotation_front_pointer <= 31 or rotation_front_pointer < -25 and rotation_front_pointer >= -31:
					rel_vel_xz = Vector2(-rel_vel.x, -rel_vel.z)
					self.set("parameters/StateMachine/Walking/blend_position", rel_vel_xz)
				elif rotation_front_pointer > 9 and rotation_front_pointer <= 25:
					rel_vel_xz = Vector2(-rel_vel.z, rel_vel.x)
					self.set("parameters/StateMachine/Walking/blend_position", rel_vel_xz)
				elif rotation_front_pointer < -9 and rotation_front_pointer >= -25:
					rel_vel_xz = Vector2(rel_vel.z, -rel_vel.x)
					self.set("parameters/StateMachine/Walking/blend_position", rel_vel_xz)

func get_rel_vel():
	rel_vel = player_controller.global_basis.inverse() * ((player_controller.velocity * Vector3(1,0,1)))
	rel_vel_xz = Vector2(rel_vel.x, rel_vel.z)
	
func rotation_of_front_pointer():
	rotation_front_pointer = round(front_pointer.global_transform.basis.get_euler().y *10)
	return rotation_front_pointer

func calc_dash_timer(delta):
	if dash_timer > 0:
		dash_timer -= delta

func calc_dash():
	if (settings.stamina >= staminaCostPerDash and settings.stamina <= maxStamina):
		dash = true
	elif (settings.stamina >= 0 and settings.stamina <= staminaCostPerDash):
		dash = false
