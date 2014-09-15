Button = class()

function Button:init(displayName, buttonAction)
    -- you can accept and set parameters here
    self.displayName = displayName
    self.fontsize = 22
    
    self.pos = vec2(0,0)
    self.size = vec2(0,0)
    self.action = nil
    self.action = buttonAction
    self.color = color(113, 66, 190, 255)
end

function Button:draw()
    fontSize(self.fontsize)
    if isKeyboardShowing() == true then
        return
    end
    -- Codea does not automatically call this method
    pushStyle()
    fill(self.color)
    
    -- use name for size
    local w,h = textSize(self.displayName)
    w = w + 20
    h = self.fontsize + 30
    
    roundRect(self.pos.x - w/2,
              self.pos.y - h/2,
              w,h,20)
            
    self.size = vec2(w,h)
            
    textMode(CENTER)
    fill(54, 65, 96, 255)
    text(self.displayName,self.pos.x+2,self.pos.y-2)
    fill(255, 255, 255, 255)
    text(self.displayName,self.pos.x,self.pos.y)
    
    popStyle()
end

function Button:hit(p)
    local l = self.pos.x - self.size.x/2
    local r = self.pos.x + self.size.x/2
    local t = self.pos.y + self.size.y/2
    local b = self.pos.y - self.size.y/2
    if p.x > l and p.x < r and
       p.y > b and p.y < t then
        return true
    end
    
    return false
end

function Button:touched(touch)
    -- Codea does not automatically call this method
    if touch.state == ENDED and
       self:hit(vec2(touch.x,touch.y)) then
        if self.action then
            self.action()
        end
    end
end
