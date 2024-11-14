extends State


@export var curve : Curve

## Speed of the kick slam. Default: 300
@export var curve_factor = 300
var curve_time = 0.0


func update(delta):
    player.gravity(delta)
    slam()

    if player.slamming:
        if player.is_on_floor():
            curve_time = 0.0
            player.anim_sprite.play("slam")
            player.slam_left_coll.disabled = false
            player.slam_right_coll.disabled = false
        
        if player.is_hurt:
            curve_time = 0.0
            player.slamming = false
            return states.HURT

    else:
        player.slam_left_coll.disabled = true
        player.slam_right_coll.disabled = true
        curve_time = 0.0
        
        if player.is_on_floor() and player.velocity.x == Vector2.ZERO.x:
            return states.IDLE


func enter_state():
    player.anim_sprite.play("fall")
    player.slamming = true
    player.velocity.x = Vector2.ZERO.x


func slam():
    curve_time += 0.06 
    player.velocity.y = curve.sample(curve_time) * curve_factor
    curve_time = clamp(curve_time, 0, 1)
    print("curve_time: ", curve_time)
