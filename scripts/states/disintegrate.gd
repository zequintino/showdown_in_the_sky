extends State


func update(_delta):    
    if player.disintegrated:
        player.queue_free()
    elif player.is_hurt:
        return states.HURT
    else:
        return null


func enter_state():
    player.velocity.x = Vector2.ZERO.x
    player.anim_sprite.play("disintegrate")
