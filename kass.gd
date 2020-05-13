extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal hit
signal unhit
var hxy
var mouseon

var yvel = 0
var onground
var timer = 0

export var speed = 3

var cvel = 1



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var paused = get_parent().get_parent().paused
	if paused:
		return
	timer += delta
	hxy = get_parent().get_parent().get_node("hullmyts").position
	if rand_range(0,200) < 1:
		var rand = rand_range(0,10)
		if rand < 1:
			cvel = 1
		elif rand < 9:
			cvel = 0
		else:
			cvel = -1
	var vel = Vector2(cvel,0)
	#vel.y = yvel
	vel.x = sign(vel.x)
	vel = vel*speed
	vel.y = yvel
	move_and_slide(vel*60)
		
	#move_and_slide(Vector2(0,yvel)/delta)
	for i in get_slide_count():
		var c = get_slide_collision(i)
		#print(c.normal)
		if onground and c.normal.x != 0:
			#print(c.normal)
			yvel = -10
			#onground = false
	if not onground:
		yvel += 1
	if Input.is_action_just_pressed("LCLICK") and mouseon:
		#get_parent().get_parent().get_node("hud").kolliv += 1
		cvel = (hxy-position).x
	if (position-hxy).x + (position-hxy).y > 1280:
		queue_free()

func _on_Area2D_mouse_entered():
	mouseon = true

func _on_Area2D_mouse_exited():
	mouseon = false


func _on_groundboxx_body_entered(body):
	if body != self:
		onground = true
		#print(body)


func _on_groundboxx_body_exited(body):
	if body != self:
		onground = false
		#print('rf ',body)
