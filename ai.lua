return function(self)
	self.cmd={}
	local carSpeed=	self.tires[3]:getForwardVelocity():len()
	local testPos=self.posInRoad+math.ceil(carSpeed/200)+2
	self.testPos=testPos
	if testPos>game.road.count then testPos=testPos-game.road.count end
	if testPos<=0 then testPos=testPos+#road.blocks end
	local testX,testY=game.road.blocks[testPos].body:getPosition()
	local localX,localY=self.body:getLocalPoint(testX,testY)
	local localAngle=math.getRot(localX,localY,0,0)
	if localAngle>math.pi then localAngle=localAngle-2*math.pi end
	if localAngle<-math.pi/8 then table.insert(self.cmd,"left") end
	if localAngle>math.pi/8 then table.insert(self.cmd,"right") end
	if math.abs(localAngle)<math.pi/6 then table.insert(self.cmd,"forward") end
	if math.abs(localAngle)>math.pi/3 then table.insert(self.cmd,"brake") end
	--if math.abs(localAngle)>math.pi/3 then table.insert(self.cmd,"back") end
	if carSpeed<=100 then table.insert(self.cmd,"reset") end
	if self.stop>=100 then table.insert(self.cmd,"back") end
	if carSpeed<=100 then table.insert(self.cmd,"forward") end
end