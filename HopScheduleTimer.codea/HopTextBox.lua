HopTextBox = class()

function HopTextBox:init()
    
    self.text=""
    self.hint="Enter hop details here"

    self.pos = vec2(0,0)
    self.size = vec2(0,0)
    self.focus=false
    self.fontsize=0

end

function HopTextBox:draw()
    fontSize(self.fontsize)
    if isKeyboardShowing() == false and self.focus == true then
        self.focus=false
    end
    
    pushStyle()    
    fill(240)
    
    local w,h
    w = self.fontsize * 19
    h = self.fontsize * 2
    
    posx = self.pos.x
    posy = self.pos.y
    
    if isKeyboardShowing() == true and self.focus == true then
        fill(69, 206, 14, 255)
        posy=HEIGHT/2   
    end
       if isKeyboardShowing() == true and self.focus == false then
        fill(145, 156, 141, 255)
        
        if posy-(self.fontsize * 2)<HEIGHT/2 then
            posy=0
        end
    end

    
    roundRect(posx - w/2,
    posy - h/2,
    w,h,self.fontsize)
    
    --For Blink
    self.size = vec2(w,h)
    stroke(0,10,255,255)
    strokeWidth(3)
    lineCapMode(SQUARE)
    
    if blink() and self.focus==true then
        a=((posx*2)/2+textSize(self.text)/2)+3
        b=posy+(self.fontsize*3/4)
        c=posy-(self.fontsize*3/4)
        line(a,b,a,c)
    end
    
    textMode(CENTER)
    local t=""
    if self.text=="" then
        fill(90)
        t=self.hint
    else
        fill(0)
        t=self.text
    end
    text(t,posx,posy)

         
    popStyle()
end

function HopTextBox:hit(p)
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

function HopTextBox:touched(touch)
    -- Codea does not automatically call this method
    if touch.state == ENDED and self:hit(vec2(touch.x,touch.y)) then
        self.focus=true
        showKeyboard()
        if self.action then
            self.action()
        end
        else
        self.focus=false
       -- hideKeyboard()
    end
end

function HopTextBox:keyboard(key)
    if self.focus==true then
        if key==BACKSPACE then
            if string.len(self.text)>0 then
                self.text=string.sub(self.text,1,string.len(self.text)-1)
            end
            elseif key == RETURN then 
                hideKeyboard()
                self.focus=false
            else
            if string.len(self.text)<28 then
            self.text=self.text .. key
                end
        end
    end
end

function blink()
    local int,fract=math.modf(ElapsedTime)
    if fract>=0.5 then return true else return false end
end

function HopTextBox:getText()
    if (self.text == "") then return "Hop"
    else    return self.text end
end
