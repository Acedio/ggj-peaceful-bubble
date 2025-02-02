function wobubble()
  return {
    t=0,
    trail=v2(0,0),
    update=function(self, dx, dy)
      if dy < 0 then
        self.trail.y = min(3, self.trail.y + 1.5)
      elseif dy > 0 then
        self.trail.y = max(-2, self.trail.y - 0.5)
      end
      if dx < 0 then
        self.trail.x = min(3, self.trail.x + 1.5)
      elseif dx > 0 then
        self.trail.x = max(-2, self.trail.x - 0.5)
      end
      self.trail *= 0.8
      self.t += 1
    end,
    draw=function(self, x, y, r)
      local t = self.t
      if self.size == "big" then
        r = 8
      end
      local function draw_layer(x, y, r, c)
        -- How great is the trail's X magnitude relative to the Y?
        local x_winning = (2+abs(self.trail.x) - abs(self.trail.y))/5-0.5;
        local xr = r * (1 + x_winning/2)
        local yr = r * (1 - x_winning/2)
        oval(x-xr,y-yr,x+xr,y+yr,c)
      end
      local rf = function(t) return r/4*(0.5+sin(cos(t/400))) end
      draw_layer(x+self.trail.x,y+self.trail.y,r+rf(t-5),11)
      if t%2 == 0 then
        draw_layer(x+self.trail.x/2,y+self.trail.y/2,r+rf(t-2),1)
      else
        draw_layer(x+self.trail.x/2,y+self.trail.y/2,r+rf(t-2),3)
      end
      -- Draw the oil spot before the top layer.
      spr(17, x-(r+rf(t))*0.7, y-(r+rf(t))*0.7)
      draw_layer(x,y,r+rf(t),2)
    end,
  }
end
