MakeChoice = class()

function MakeChoice:init(choiceText, negativeAction, positiveAction)
    -- you can accept and set parameters here
    self.choiceText = choiceText
    self.fontsize = 0
    self.color = color(19, 65, 69, 255)

    self.pos = vec2(0,0)
    self.size = vec2(0,0)
    
    yesButton = Button("Yes")
    yesButton.action = positiveAction
    noButton = Button("No")
    noButton.action = negativeAction


end

function MakeChoice:draw()
    fontSize(self.fontsize)
    
   pushStyle()
   fill(self.color)
    
    -- use name for size
    local w,h = textSize(self.choiceText)
    w = w+(self.fontsize*2)
    h = self.fontsize * 2
    
    roundRect(self.pos.x - w/2, self.pos.y-(h),w,h,self.fontsize *3)
            
    self.size = vec2(w,h)
            
    textMode(CENTER)
    fill(54, 65, 96, 255)
    text(self.choiceText,self.pos.x,self.pos.y)
    fill(255, 255, 255, 255)
    text(self.choiceText,WIDTH/2,HEIGHT/2)
    
    yesButton.pos = vec2(WIDTH/2+(self.fontsize*5) ,self.pos.y-(self.fontsize*4))
    yesButton.fontsize=self.fontsize
    yesButton:draw()
    noButton.pos = vec2(WIDTH/2-(self.fontsize*5) ,self.pos.y-(self.fontsize*4))
    noButton.fontsize=self.fontsize

    noButton:draw()
    
    
    popStyle()
end


function MakeChoice:touched(touch)
    noButton:touched(touch)
    yesButton:touched(touch)

end

