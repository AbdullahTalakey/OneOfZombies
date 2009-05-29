class Zombie < Sprite
  attr_reader :x, :y
  attr_accessor :life
  
  def initialize(window)
    self.warp(0,0)
    @angle = rand( (360 * 2) + 1 ) - 360 
    @life = rand(Conf::ZOMBIE_LIFE) + 1
    @window = window
    @image = @window.tb.sprite_images[:zombie]
    @z = ZOrder::Hero
    @velocity = rand() * Conf::ZOMBIE_VELOCITY
    
    super() 
  end

  def warp(x, y)
    @x = x
    @y = y
  end
  
  def move
    
    if self.see_hero?
      @angle = Gosu::angle(@x, @y, @window.hero.x, @window.hero.y)
    else
      if rand(Conf::ZOMBIE_TURN_DECISION) == 0
        @angle += rand( (Conf::ZOMBIE_TURN_VELOCITY * 2) + 1 ) - Conf::ZOMBIE_TURN_VELOCITY
      end
    end
      
    possible_x = @x + Gosu::offset_x( @angle, @velocity )
    possible_y = @y + Gosu::offset_y( @angle, @velocity )
    
    if !@window.map.any_touched_tile_is_not?( :walkable, possible_x, possible_y, @width/3, @height/3 )
      @x = possible_x
      @y = possible_y
    end
    
    # se da la vuelta
    if(
      @x > (@window.map.width * 40) ||
      @x < 0 ||
      @y > (@window.map.height * 40) ||
      @y < 0
    ) 
      @angle += 90
    end
  end
  
  def retroceso( angle )
    @x += Gosu::offset_x( angle, Conf::BULLET_RETROCESO )
    @y += Gosu::offset_y( angle, Conf::BULLET_RETROCESO )
  end

  def see_hero?
    Gosu::distance(@x, @y, @window.hero.x, @window.hero.y) < Conf::ZOMBIE_SAW
  end
  
  def draw_inner( x, y )
    super
    @window.font.draw("#{life}", x - 20 , y - 30 , @z, 1.0, 1.0, 0xffff0000)
  end

end