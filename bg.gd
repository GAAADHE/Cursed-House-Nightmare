extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var p = null
var lastFrame = 0
var maxFrame = null
var isActived = false
export var widthbg = 100
export var heightbg = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	if(true):
		
		pass
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!isActived):
		p = $AnimatedSprite
		maxFrame = p.get_sprite_frames().get_frame_count("default")
		isActived = true
	#condiction for no use a lot of cpu
	if(isActived):
		if(p.is_playing()):
			if(p.frame + 1 > maxFrame):#reset
				lastFrame = 0
				pass
			else:
				if(p.frame != lastFrame):
					lastFrame+=1
					#update frame of bg
					var text_sub = AtlasTexture.new()
					var text_animation = (p.get_sprite_frames().get_frame("default",p.frame))
					
					
					#print(text_animation.get_class())
					text_sub.set_atlas(text_animation)
					#text_sub.set_region(Rect2(Vector2(0,0),Vector2(1000,1000)))
					text_sub.set_region(Rect2(Vector2(0,0),Vector2(widthbg,heightbg)))
					#print(text_sub.get_atlas().flags)
					text_sub.set_flags(2)
					set_texture(text_sub)
					#print(get_texture().get_flags())
					#print(get_texture().set_flags(7))
					#print(get_texture().get_class())
					"""
					if(get_texture().get_class() == "StreamTexture" and "set_region" in get_texture()):
						get_texture().set_region(Vector2(0,0),Vector2(1000,1000))
						print("region seted")
					"""	
				
			pass
	pass
