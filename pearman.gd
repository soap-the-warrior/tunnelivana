extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal hit
signal unhit
var hxy
var killable

var yvel = 0
var onground
var timer = 0

export var speed = 2.5

var tulepall = preload("tulepall.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var paused = get_parent().get_parent().paused
	if paused:
		return
	timer += delta
	hxy = get_parent().get_parent().get_node("hullmyts").position + Vector2(16,16)
	var vel =  hxy-position
	#vel.y = yvel
	vel.x = sign(vel.x)
	vel = vel*speed
	vel.y = yvel
	move_and_slide(vel/delta)
	if timer >= 2:
		timer = 0
		var pew = tulepall.instance()
		get_parent().get_parent().get_node("tulepallid").add_child(pew)
		pew.position = position
		pew.vel = (hxy-position).normalized() * 6
		pew.scale = Vector2(2,2)
		
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
	if Input.is_action_just_pressed("LCLICK") and killable:
		get_parent().get_parent().get_node("hud").collect(8)
		queue_free()

func _on_Area2D_mouse_entered():
	killable = true

func _on_Area2D_mouse_exited():
	killable = false


func _on_groundboxx_body_entered(body):
	if body != self:
		onground = true
		#print(body)


func _on_groundboxx_body_exited(body):
	if body != self:
		onground = false
		#print('rf ',body)