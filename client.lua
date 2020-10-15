local render

function dxDrawRoundedRectangle(radius,x,y,w,h,color,postGUI,subPixel,noTL,noTR,noBL,noBR)
	local noTL = not noTL and dxDrawCircle(x+radius,y+radius,radius,180,270,color,color,9,1,postGUI) -- top left corner
	local noTR = not noTR and dxDrawCircle(x+w-radius,y+radius,radius,270,360,color,color,9,1,postGUI) -- top right corner
	local noBL = not noBL and dxDrawCircle(x+radius,y+h-radius,radius,90,180,color,color,9,1,postGUI) -- bottom left corner
	local noBR = not noBR and dxDrawCircle(x+w-radius,y+h-radius,radius,0,90,color,color,9,1,postGUI) -- bottom right corner
	dxDrawRectangle(x+radius-(not noTL and radius or 0),y,w-2*radius+(not noTL and radius or 0)+(not noTR and radius or 0),radius,color,postGUI,subPixel) -- top rectangle
	dxDrawRectangle(x,y+radius,w,h-2*radius,color,postGUI,subPixel) -- center rectangle
	dxDrawRectangle(x+radius-(not noBL and radius or 0),y+h-radius,w-2*radius+(not noBL and radius or 0)+(not noBR and radius or 0),radius,color,postGUI,subPixel)-- bottom rectangle
end
function isMouseInPosition(x,y,w,h)
	if not isCursorShowing() then
		return false
	end
	local sx,sy = guiGetScreenSize()
	local cx,cy = getCursorPosition()
	local cx,cy = (cx*sx),(cy*sy)
	return ((cx >= x and cx <= x+w) and (cy >= y and cy <= y+h))
end
sx,sy = guiGetScreenSize()

settings = {
	["panelSize"] = {240,480},
}

scrolls = {
--[[
	{
		["id"] = "shader ismi",
		["interval"] = {min değer,max değer},
		["text"] = "bar yazısı",
		["percent"] = 0 to 1;
	},
]]--
	{
		["id"] = "speed",
		["interval"] = {1,10},
		["text"] = "Speed",
		["percent"] = 0.5,
	},
	{
		["id"] = "rate",
		["interval"] = {1,30},
		["text"] = "Rate",
		["percent"] = 0.5,
	},
	{
		["id"] = "intensity",
		["interval"] = {0,1},
		["text"] = "Color Intensity / Saturation",
		["percent"] = 0.0,
	},
	{
		["id"] = "color.a",
		["interval"] = {0,1},
		["text"] = "Transparency",
		["percent"] = 1.0,
	},
	{
		["id"] = "color.r",
		["interval"] = {0,1},
		["text"] = "Red",
		["percent"] = 1.0,
	},
	{
		["id"] = "color.g",
		["interval"] = {0,1},
		["text"] = "Green",
		["percent"] = 1.0,
	},
	{
		["id"] = "color.b",
		["interval"] = {0,1},
		["text"] = "Blue",
		["percent"] = 1.0,
	},
}


maxShader = 20
currentShader = 1
drawingShader = dxCreateShader("prac"..currentShader..".fx", 1, 100, true)

-- dokunmasan iyi edersin
settings["panelPos"] = {sx-settings["panelSize"][1],(sy-settings["panelSize"][2])/2}

function renderFunc()
	-- panel
	dxDrawRoundedRectangle(10,settings["panelPos"][1],settings["panelPos"][2],settings["panelSize"][1],settings["panelSize"][2],0xaa000000,true)
	-- shader & arkası
	dxDrawRoundedRectangle(10,settings["panelPos"][1]+10,settings["panelPos"][2]+10,settings["panelSize"][1]-20,settings["panelSize"][1]-20,0x50808080,true)
	dxDrawImage(settings["panelPos"][1]+20,settings["panelPos"][2]+20,settings["panelSize"][1]-40,settings["panelSize"][1]-40,drawingShader,nil,nil,nil,true)
	-- we need them
	local posx = settings["panelPos"][1]+10
	local w = settings["panelSize"][1]-20
	-- önceki ve sonraki butonları & şuanki shader
	local posy = settings["panelPos"][2]+settings["panelSize"][1]-5
	dxDrawRectangle(posx+25,posy,w-50,25,0x50BBBBBB,true)
	dxDrawRoundedRectangle(5,posx,posy,25,25,0xFFBBBBBB,true,false,false,true,false,true)
	dxDrawRoundedRectangle(5,posx+w-25,posy,25,25,0xFFBBBBBB,true,false,true,false,true,false)
	dxDrawText("◄",posx,posy,posx+25,posy+25,0xccffffff,nil,"default","center","center",nil,nil,true)
	dxDrawText("►",posx+w,posy,posx+w-25,posy+25,0xccffffff,nil,"default","center","center",nil,nil,true)
	dxDrawText(currentShader.." / "..maxShader,posx,posy,posx+w,posy+25,nil,nil,"default-bold","center","center",nil,nil,true)
	-- scrollbarlar
	for i=1,#scrolls do
		local t = scrolls[i]
		local posy = settings["panelPos"][2]+settings["panelSize"][1]+i*25
		dxDrawRectangle(posx+20,posy,w-40,20,0x50808080,true)
		dxDrawRoundedRectangle(5,posx,posy,20,20,0xFF808080,true,false,false,true,false,true)
		dxDrawRoundedRectangle(5,posx+w-20,posy,20,20,0xFF808080,true,false,true,false,true,false)
		dxDrawText(t["interval"][1],posx+2,posy,posx+20,posy+20,0xccffffff,nil,"default","center","center",nil,nil,true)
		dxDrawText(t["interval"][2],posx+w,posy,posx+w-20,posy+20,0xccffffff,nil,"default","center","center",nil,nil,true)
		dxDrawText(t["text"].." : "..("%.2f"):format((t["interval"][2]-t["interval"][1])*t["percent"]+t["interval"][1]),posx,posy,posx+w,posy+20,0xccffffff,nil,"default-bold","center","center",nil,nil,true)
		dxDrawRoundedRectangle(5,posx+20+(w-60)*t["percent"],posy,20,20,0xFF606060,true)
		dxDrawText("◄►",posx+20+(w-60)*t["percent"],posy,posx+20+(w-60)*t["percent"]+20,posy+20,0xccffffff,.6,"default","center","center",nil,nil,true)
	end
	-- uygula butonu dayı
	local posy = settings["panelPos"][2]+settings["panelSize"][1]+#scrolls*25+30
	dxDrawRoundedRectangle(5,posx,posy,w,25,0x50BBBBBB,true)
	dxDrawText("Apply",posx,posy,posx+w,posy+25,nil,nil,"default-bold","center","center",nil,nil,true)
end

addCommandHandler("shader",function()

	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not (vehicle and getVehicleController(vehicle) == localPlayer) then return end

	render = not render

	removeEventHandler("onClientRender",root,renderFunc)
	showCursor(false)

	if render then
		addEventHandler("onClientRender",root,renderFunc)
		showCursor(true)
	end
end)

function cleanUp()
	if source ~= localPlayer then return end

	if render then
		removeEventHandler("onClientRender",root,renderFunc)
		showCursor(false)
	end
end
addEventHandler("onClientPlayerVehicleExit", localPlayer, cleanUp)

addEventHandler("onClientClick",root,function(btn,st)
	if not render then return end
	if btn == "left" then
		local posx = settings["panelPos"][1]+10
		local w = settings["panelSize"][1]-20
		if st == "down" then -- mouse indiğinde
			if isMouseInPosition(posx,settings["panelPos"][2]+settings["panelSize"][1]-5,25,25) then -- önceki shader butonu
				currentShader = currentShader-1
				currentShader = currentShader < 1 and maxShader or currentShader
				--engineRemoveShaderFromWorldTexture(drawingShader, "vehiclegrunge256")
				destroyElement(drawingShader)
				drawingShader = dxCreateShader("prac"..currentShader..".fx", 1, 100, true)
				applyShaderValues(drawingShader)
				return
			elseif isMouseInPosition(posx+w-25,settings["panelPos"][2]+settings["panelSize"][1]-5,25,25) then -- sonraki shader butonu
				currentShader = currentShader+1
				currentShader = currentShader > maxShader and 1 or currentShader
				--engineRemoveShaderFromWorldTexture(drawingShader, "vehiclegrunge256")
				destroyElement(drawingShader)
				drawingShader = dxCreateShader("prac"..currentShader..".fx", 1, 100, true)
				applyShaderValues(drawingShader)
				return
			end
			for i=1,#scrolls do -- scroll kutucukları
				local posy = settings["panelPos"][2]+settings["panelSize"][1]+i*25
				if isMouseInPosition(posx+20+(w-60)*scrolls[i]["percent"],posy,20,20) then
					holded = i
					return
				end
			end
		else -- mouse kalktığında
			if holded then -- eğer scroll kutucuğu tutulmuşsa
				local t = scrolls[holded]
				if not t["id"]:find("color") then -- id de 'color' bulunmuyosa değeri direkt ayarla
					dxSetShaderValue(drawingShader,t["id"],(t["interval"][2]-t["interval"][1])*t["percent"]+t["interval"][1])
				else -- id de 'color' varsa tüm renkleri çekip uygular
					local colors = {}
					for i=1,#scrolls do
						if scrolls[i]["id"]:find("color.") then
							colors[scrolls[i]["id"]:gsub("color.","")] = (scrolls[i]["interval"][2]-scrolls[i]["interval"][1])*scrolls[i]["percent"]+scrolls[i]["interval"][1]
						end
					end
					dxSetShaderValue(drawingShader,"color",{colors["r"],colors["g"],colors["b"],colors["a"]})
				end
				holded = nil
			else
				for i=1,#scrolls do -- scroll min-max değerlere tıklayarak değer değiştirme
					local posy = settings["panelPos"][2]+settings["panelSize"][1]+i*25
					local change = 0.01/(scrolls[i]["interval"][2]-scrolls[i]["interval"][1])
					if isMouseInPosition(posx,posy,20,20) then
						scrolls[i]["percent"] = scrolls[i]["percent"] - change > 0 and scrolls[i]["percent"] - change or 0
						applyShaderValues(drawingShader)
						return
					elseif isMouseInPosition(posx+w-20,posy,20,20) then
						scrolls[i]["percent"] = scrolls[i]["percent"] + change < 1 and scrolls[i]["percent"] + change or 1
						applyShaderValues(drawingShader)
						return
					end
				end
				local posy = settings["panelPos"][2]+settings["panelSize"][1]+#scrolls*25+30
				if isMouseInPosition(posx,posy,w,25) then -- uygula butonuysa
					local vehicle = getPedOccupiedVehicle(localPlayer)
					if vehicle and getVehicleController(vehicle) == localPlayer then
						if getPedOccupiedVehicleSeat(localPlayer) == 0 then
							local values = {}
							for i=1,#scrolls do
								values[i] = {
									["id"] = scrolls[i]["id"],
									["interval"] = scrolls[i]["interval"],
									["percent"] = scrolls[i]["percent"],
								}
							end
							setElementData(vehicle,"shaderData",{currentShader,values})
						end
					end
				end
			end
		end
	end
end)

addEventHandler("onClientElementDataChange",root,function(key,old,new)
	if getElementType(source) == "vehicle" and key == "shaderData" and type(new[1]) == "number" and type(new[2]) == "table" then
		applyVehiclesShader(source)
	end
end)

vehicleShaders = {}
function applyVehiclesShader(vehicle)
	local shaderT = getElementData(vehicle,"shaderData")
	if vehicleShaders[vehicle] then
		destroyElement(vehicleShaders[vehicle])
	end
	vehicleShaders[vehicle] = dxCreateShader("prac"..shaderT[1]..".fx", 1, 100, true)
	setElementParent(vehicleShaders[vehicle],vehicle)
	applyShaderValues(vehicleShaders[vehicle],shaderT[2])
	engineApplyShaderToWorldTexture(vehicleShaders[vehicle], "vehiclegrunge256", vehicle)
end

function applyShaderValues(shader,values)
	if not shader then return end
	local values = values or scrolls
	local colored = false
	for i=1,#values do
		local t = values[i]
		if not t["id"]:find("color") then -- id de 'color' bulunmuyosa değeri direkt ayarla
			dxSetShaderValue(shader,t["id"],(t["interval"][2]-t["interval"][1])*t["percent"]+t["interval"][1])
		else -- id de 'color' varsa tüm renkleri çekip uygular
			if not colored then
				local colors = {}
				for i=1,#values do
					if values[i]["id"]:find("color.") then
						colors[values[i]["id"]:gsub("color.","")] = (values[i]["interval"][2]-values[i]["interval"][1])*values[i]["percent"]+values[i]["interval"][1]
					end
				end
				dxSetShaderValue(shader,"color",{colors["r"],colors["g"],colors["b"]})
				colored = true
			end
		end
	end
end
applyShaderValues(drawingShader)

addEventHandler("onClientCursorMove",root,function(x,y)
	if not render then return end
	if holded then
		local x,y = sx*x,sy*y
		local posx = settings["panelPos"][1]+10
		local w = settings["panelSize"][1]-20
		scrolls[holded]["percent"] = (x-posx-30)/(w-60)
		scrolls[holded]["percent"] = (scrolls[holded]["percent"] < 0 and 0) or (scrolls[holded]["percent"] > 1 and 1) or scrolls[holded]["percent"]
	end
end)