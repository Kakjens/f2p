--checks for 16 slot bags
local itemset = {}
--local addonname = "f2p"
--GetBuybackItemInfo
--[[
local fishcookhorde={}
Stag eye
Corpse Worm
Bloaed Frog
Alliance Decoy Kit
69956, --Blind Cavefish
]]

local _
local at_vendor = false
itemset = {
	[1] = 40533, --"Walnut Stock",
	[2] = 38426, --"Eternium Thread",
	[3] = 18567, --"Elemental Flux",
	[4] = 67398, --Dazzling Sapphire Pendant
}
local numIte = #itemset

local hordebags = {
	[1] = 67533, --Orgrimmar Satchel
	[2] = 67536, --Darkspear Satchel
	[3] = 67525, --Bilgewater Satchel
	[4] = 67534, --Thunder Bluff Satchel
	[5] = 67535, --Silvermoon Satchel
	[6] = 67529, --Undercity Satchel
	[7] = 92070, --Huojin Satchel
}
local hordereps = {
	[1] = 76, --Orgrimmar
	[2] = 530, --Darkspear Trolls
	[3] = 1133, --Bilgewater Cartel
	[4] = 81, --Thunder Bluff
	[5] = 911, --Silvermoon City
	[6] = 68, --Undercity
	[7] = 1352, --Huojin Pandaren
}
local hordetabards = {
	[1] = 45581, --Orgrimmar
	[2] = 45582, --Senjin
	[3] = 64884, --Bilgewater Cartel
	[4] = 45584, --Thunder Bluff
	[5] = 45585, --Silvermoon City
	[6] = 45583, --Undercity
	[7] = 83080, --Huojin Pandaren
}
local alliancebags = {
	[1] = 67531, --Stormwind Satchel
	[2] = 67528, --Ironforge Satchel
	[3] = 67532, --Gilnean Satchel
	[4] = 67530, --Gnomeregan Satchel
	[5] = 67527, --Exodar Satchel
	[6] = 67526, --Darnassian Satchel
	[7] = 92071, --Tushui Satchel
}
local alliancereps = {
	[1] = 72, --Stormwind
	[2] = 47, --Ironforge
	[3] = 1134, --Gilneas
	[4] = 54, --Gnomeregan
	[5] = 930, --Exodar
	[6] = 69, --Darnassus
	[7] = 1353, --Tushui Pandaren
}
local alliancetabards = {
	[1] = 45574, --Stormwind
	[2] = 45577, --Ironforge
	[3] = 64882, --Gilneas
	[4] = 45578, --Gnomeregan
	[5] = 45580, --Exodar
	[6] = 45579, --Darnassus
	[7] = 83079, --Tushui Pandaren
}
local myreps = {}
local mybags = {}
local mytabards = {}
local numbags = #hordebags + 1

local w = 36
local w1 = w * 1.15
local h = 36
--local h1 = h * 1.15
local x
local y

local which = {}
local which_bag = {}
local stage_bag = {}
local vendorprice = {}
local tabarditems = {}


local f2pDragFrame = CreateFrame("Frame", "f2pDragFrame", UIParent)
f2pDragFrame:ClearAllPoints()
f2pDragFrame:SetPoint("CENTER", 0, 0)
f2pDragFrame:SetScale(1)
f2pDragFrame:SetWidth(260)
f2pDragFrame:SetHeight(w1*(numIte+1)+20)
f2pDragFrame:Show()
--Basic draggable frames
f2pDragFrame:RegisterForDrag("LeftButton")
f2pDragFrame:EnableMouse(true)
f2pDragFrame:SetClampedToScreen(true)
f2pDragFrame:SetMovable(true)
f2pDragFrame:SetScript("OnDragStart", f2pDragFrame.StartMoving)
f2pDragFrame:SetScript("OnDragStop", f2pDragFrame.StopMovingOrSizing)

local texture=f2pDragFrame:CreateTexture(nil,"ARTWORK")
texture:SetAllPoints(f2pDragFrame)
texture:SetColorTexture(0, 0.75, 1, 0.7)
local f2sellbacknFS
local function createmoneyframe()
--Total Money Parent Frame
	local f2pTotalMoneyParent = CreateFrame("Frame", "f2pTotalMoneyParent", f2pDragFrame)
	f2pTotalMoneyParent:SetWidth(100)
	f2pTotalMoneyParent:SetHeight(28)
	f2pTotalMoneyParent:ClearAllPoints()
	f2pTotalMoneyParent:SetPoint("TOPLEFT", f2pDragFrame, "TOPLEFT", 30, -10)
	local f2pTotalMoney = CreateFrame("Frame", "f2pTotalMoney", f2pDragFrame,"TooltipMoneyFrameTemplate")
	--f2pTotalMoney:RegisterEvent("PLAYER_LOGIN")
	f2pTotalMoney:RegisterEvent("PLAYER_ENTERING_WORLD")
	--f2pTotalMoney:SetWidth(200)
	--f2pTotalMoney:SetHeight(28)
	f2pTotalMoney:ClearAllPoints()
	f2pTotalMoney:SetPoint("TOPRIGHT", f2pTotalMoneyParent, "TOPRIGHT", 0, 0)
	f2pTotalMoney:Show()

	--Debugging Texture
	f2pTotalMoney.f2pTexture=f2pTotalMoney:CreateTexture(nil,"ARTWORK")
	f2pTotalMoney.f2pTexture:SetAllPoints(f2pTotalMoney)
	--f2pTotalMoney.f2pTexture:SetColorTexture(0.3, 0.75, 0.1, 1)--Optional Color
	f2pTotalMoney.f2pTexture:SetColorTexture(0.15, 0.15, 0.15, 0.7)
	
	
	f2sellbacknFS = f2pDragFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	--f2sellbacknFS:SetText('To see money required to\n buy back the items, visit a vendor')
	f2sellbacknFS:SetText('Visit a vendor')
	f2sellbacknFS:SetPoint("TOPRIGHT", -10, -10)
	f2sellbacknFS:SetFont("Fonts\\FRIZQT__.TTF", 14)
end

local clicked_tabard
local INVSLOT_TABARD = INVSLOT_TABARD
local function track_rep()
	local tabardid = GetInventoryItemID("player", INVSLOT_TABARD)
	local temp = myreps[tabarditems[tabardid]]
	local factionIndex = 1
	local lastFactionName
	repeat
		local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfo(factionIndex)
		if name == lastFactionName then break end
		lastFactionName  = name
		if factionID == temp then
			--print(name,factionID,temp)
			SetWatchedFactionIndex(factionIndex)
			--print(factionIndex)
		end
		factionIndex = factionIndex + 1
	until factionIndex > 200
end
local tabard_checker = CreateFrame('Frame')
tabard_checker:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
tabard_checker:RegisterEvent("PLAYER_ENTERING_WORLD")
tabard_checker:SetScript('OnEvent', function(self, event, slot,hasItem)
	if event == "PLAYER_EQUIPMENT_CHANGED" then
		if slot == INVSLOT_TABARD then
			if hasItem then
				track_rep()
			end
		end
	else --if event == "PLAYER_ENTERING_WORLD"
		track_rep()
	end
end)



local regen_enabled = "PLAYER_REGEN_ENABLED"
local tabard_equipper = CreateFrame('Frame')
tabard_equipper:SetScript('OnEvent', function(self, event, ...)
	if event == regen_enabled then
		EquipItemByName(clicked_tabard)
		self:UnregisterEvent(event)
	end
end)

local write_clicking

local function verify_tabard(tabardID,tabardlink)
	if IsEquippedItem(tabardID) then
		print(tabardlink, "is already equipped")
	else
		if InCombatLockdown() then
			print(tabardlink,"will be equipped upon leaving combat.")
			tabard_equipper:RegisterEvent(regen_enabled)
		else
			EquipItemByName(clicked_tabard)
		end
	end
end

local function createbagframe(itemID)
	local _, itemLink, _,_,_,_,_,_,_,itemTexture,vndrprc = GetItemInfo(itemID)
	vendorprice[itemID] = vndrprc
	if not _G["f2pbag"..itemID] then
		--print("creating",itemID)
		--local f2pDisplay = CreateFrame("Frame", "f2pDisplay"..itemID, f2pDragFrame)
		local f2pbag = CreateFrame("Button", "f2pbag"..itemID, f2pDragFrame)
		y = which_bag[itemID] * w1
		if stage_bag[itemID] then x = -5 else x = -60 end
		--print(itemname,itemName)
		f2pbag:ClearAllPoints()
		f2pbag:SetPoint("BOTTOMRIGHT", x, y+40)
		f2pbag:SetSize(w, h)
		--f2pbag:SetTexture(itemTexture)
		f2pbag:SetNormalTexture(itemTexture)
		f2pbag:SetPushedTexture(itemTexture)
		f2pbag:SetHighlightTexture(itemTexture)
		
		f2pbag.reptexture = f2pbag:CreateTexture(nil,"ARTWORK")
		f2pbag.reptexture:ClearAllPoints()
		--f2pbag.reptexture:SetPoint("BOTTOMLEFT",f2pbag,"BOTTOMRIGHT",0,1)
		f2pbag.reptexture:SetPoint("BOTTOMRIGHT",f2pbag,"BOTTOMLEFT",-1,1)
		f2pbag.reptexture:SetColorTexture(1, 0, 1)
		f2pbag.totalreptexture = f2pbag:CreateTexture(nil,"ARTWORK")
		f2pbag.totalreptexture:ClearAllPoints()
		f2pbag.totalreptexture:SetPoint("BOTTOMRIGHT",f2pbag,"BOTTOMLEFT",-7,1)
		f2pbag.totalreptexture:SetColorTexture(0, 1, 0)
		f2pbag.currentreptexture = f2pbag:CreateTexture(nil,"ARTWORK")
		f2pbag.currentreptexture:ClearAllPoints()
		f2pbag.currentreptexture:SetPoint("BOTTOMRIGHT",f2pbag,"BOTTOMLEFT",-13,1)
		f2pbag.currentreptexture:SetColorTexture(1, 1, 0)
		
		f2pbag.f2pbagFST = f2pbag:CreateFontString("FontString", "OVERLAY", "GameTooltipText")
		--f2pbag.f2pbagFST:SetPoint("CENTER", f2pbag)
		f2pbag.f2pbagFST:SetPoint("TOPRIGHT", f2pbag)
		--f2pbag.f2pbagFST:SetPoint("TOPLEFT", f2pbag)
		f2pbag.f2pbagFST:SetFont("Fonts\\FRIZQT__.TTF", 14, "THINOUTLINE")
		f2pbag.f2pbagFSB = f2pbag:CreateFontString("FontString", "OVERLAY", "GameTooltipText")
		--f2pbag.f2pbagFSB:SetPoint("CENTER", f2pbag)
		f2pbag.f2pbagFSB:SetPoint("BOTTOMRIGHT", f2pbag)
		--f2pbag.f2pbagFSB:SetPoint("BOTTOMLEFT", f2pbag)
		f2pbag.f2pbagFSB:SetFont("Fonts\\FRIZQT__.TTF", 14, "THINOUTLINE")

		f2pbag:Hide()
		f2pbag:HookScript("OnEnter", function(self)
			--print("f2pbag on enter")
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			--GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
			GameTooltip:SetHyperlink(itemLink)
			GameTooltip:Show()
		end)
		f2pbag:SetScript("OnClick", function(self)
			if itemID ~= 19291 and itemID ~= 80008 then --if neither Darkmoon Storage Box nor Darkmoon Rabbit
				local index = tabarditems[itemID]
				local tabardID = mytabards[index]
				local _,tabardlink =  GetItemInfo(tabardID)
				--print(tabardID,tabardlink)
				local itemcount = GetItemCount(tabardID, false, false)
				local itemcount_bank = GetItemCount(tabardID, true, false)
				--print("equip",itemLink,tabardlink,itemcount) --debug
				if clicked_tabard ~= tabardID then
					write_clicking = true
					clicked_tabard = tabardID
					if itemcount_bank  == 0 then
						print("You need to buy",tabardlink,"first")
					else
						if itemcount == 0 then
							print(tabardlink,"isn't in bags")
						else
							verify_tabard(tabardID,tabardlink)
						end
					end
				else
					if IsEquippedItem(tabardID) then
						if write_clicking then
							print(tabardlink,"already clicked")
							write_clicking = false
						end
					else
						verify_tabard(tabardID,tabardlink)
					end
				end
			end
		end)
		f2pbag:HookScript("OnLeave", GameTooltip_Hide)
	end
end

local reveredrep = 3000 + 6000 + 12000
--local maxedrep = reveredrep + 21000 + 999
local maxedrep = reveredrep + 21000
local max_size = w -2
local function updateBagCount()
	for index = 1, numbags, 1 do
		local itemID = mybags[index]
		local itemIDtab = mytabards[index]
		local itemcount_bank = GetItemCount(itemID, true, false)
		if _G["f2pbag"..itemID] and _G["f2pbag"..itemIDtab] then
			local something1 = _G["f2pbag"..itemID]
			local something2 = _G["f2pbag"..itemIDtab]
			local somethingelse
			if itemcount_bank > 0 then
				something1:Hide()
				something2:Show()
				--something2.reptexture:Hide()
				something2.totalreptexture:Hide()
				if index < numbags then
					local _, _, _, _, _, gained_rep = GetFactionInfoByID(myreps[index])
					--print(gained_rep,maxedrep)
					if gained_rep < maxedrep then
						something2:GetNormalTexture():SetDesaturated(false)
					else
						something2:GetNormalTexture():SetDesaturated(true)
					end
				end
				somethingelse = something2
			else
				something1:Show()
				something2:Hide()
				something1.reptexture:Hide()
				something1.totalreptexture:Hide()
				if index < numbags then
					local _, _, standingID, _, _, gained_rep = GetFactionInfoByID(myreps[index])
					if standingID > 6 then --more then honored
						something1:GetNormalTexture():SetDesaturated(false)
					else
						something1:GetNormalTexture():SetDesaturated(true)
						something1.reptexture:SetSize(4, max_size*gained_rep/reveredrep)
						something1.reptexture:Show()
					end
				end
				somethingelse = something1
			end
			_G["f2pbag"..itemID] = something1
			_G["f2pbag"..itemIDtab] = something2
			somethingelse.currentreptexture:Hide()
			if index < numbags then
			local _, _, _, barMin, barMax, gained_rep = GetFactionInfoByID(myreps[index])
			--print(barMin,gained_rep,barMax)
			if gained_rep < maxedrep then
				somethingelse.totalreptexture:SetSize(4, max_size*gained_rep/maxedrep)
				--somethingelse.totalreptexture:SetSize(4, max_size)
				somethingelse.totalreptexture:Show()
				somethingelse.currentreptexture:SetSize(4, max_size*(gained_rep-barMin)/(barMax-barMin))
				somethingelse.currentreptexture:Show()
			end
			local itemcount_tab = GetItemCount(itemIDtab, false, false)
			--print(itemIDtab, itemcount_tab)
			local itemcount_bank_tab = GetItemCount(itemIDtab, true, false)
			somethingelse.f2pbagFSB:SetFormattedText("%.0f", itemcount_tab)
			somethingelse.f2pbagFSB:Show()
			somethingelse.f2pbagFST:Hide()
			if itemcount_tab ~= itemcount_bank_tab then
				somethingelse.f2pbagFST:SetFormattedText("%.0f", itemcount_bank_tab)
				somethingelse.f2pbagFST:Show()
			end
			if itemcount_bank > 0 then
				_G["f2pbag"..itemIDtab] = somethingelse
			else
				_G["f2pbag"..itemID] = somethingelse
			end
		end
		end
	end
end


local info_received = 'GET_ITEM_INFO_RECEIVED'
local wait_bag = {}

local cache_writer_bag = CreateFrame('Frame')
cache_writer_bag:SetScript('OnEvent', function(self, event, ...)
	if event == info_received then
		--print("received",...)
		-- the info is now downloaded and cached
		local itemID = ...
		if wait_bag[itemID] then
			--print(itemID,"received bagID")
			createbagframe(itemID)
			wait_bag[itemID] = nil
			if not next(wait_bag) then 
				updateBagCount()
				self:UnregisterEvent(event)
				--print("cahce writer bag")
			end --test
		end
	end
end)
cache_writer_bag:RegisterEvent(info_received)

local function createbagFrames()
	--f2pInitFrame:RegisterEvent("BAG_UPDATE_DELAYED")
	if UnitFactionGroup("player") == "Horde" then
		mybags = hordebags
		myreps = hordereps
		mytabards = hordetabards
	else
	--if UnitFactionGroup("player") == "Alliance" then 
		mybags = alliancebags
		myreps = alliancereps
		mytabards = alliancetabards
	end
	mybags [numbags] = 19291 --Darkmoon Storage Box
	mytabards [numbags] = 80008 --Darkmoon Rabbit
	local where_stage = true
	for index = 1, numbags, 1 do
		local itemID = mybags[index]
		local name = GetItemInfo(itemID)
		stage_bag[itemID] = where_stage
		where_stage = not where_stage
		which_bag[itemID] = ceil(index/2)-1
		tabarditems[itemID] = index
		if name then
			createbagframe(itemID)
		else
			--add item to wait list
			wait_bag[itemID] = {}
		end
	end
	for index = 1, numbags, 1 do
		local itemID = mytabards[index]
		local name = GetItemInfo(itemID)
		stage_bag[itemID] = where_stage
		where_stage = not where_stage
		which_bag[itemID] = ceil(index/2)-1
		tabarditems[itemID] = index
		if name then
			createbagframe(itemID)
		else
			--add item to wait list
			wait_bag[itemID] = {}
		end
	end
end	





local function createoneframe(itemID)	
	local _, itemLink, _,_,_,_,_,_,_,itemTexture,vndrprc = GetItemInfo(itemID)
	vendorprice[itemID] = vndrprc
	if not _G["f2pDisplay"..itemID] then
		--print("creating",itemID)
		--local f2pDisplay = CreateFrame("Frame", "f2pDisplay"..itemID, f2pDragFrame)
		local f2pDisplay = CreateFrame("Button", "f2pDisplay"..itemID, f2pDragFrame)
		y = (which[itemID]-1) * w1
		x = 10
		--print(itemname,itemName)
		f2pDisplay:ClearAllPoints()
		f2pDisplay:SetPoint("BOTTOMLEFT", x, y+40)
		f2pDisplay:SetSize(w, h)
		--f2pDisplay:SetTexture(itemTexture)
		f2pDisplay:SetNormalTexture(itemTexture)
		f2pDisplay:SetPushedTexture(itemTexture)
		f2pDisplay:SetHighlightTexture(itemTexture)
		
		f2pDisplay.f2ppriceframe = CreateFrame("Button", "f2ppriceframe"..itemID, f2pDisplay)
		f2pDisplay.f2ppriceframe:ClearAllPoints()
		f2pDisplay.f2ppriceframe:SetPoint("BOTTOMLEFT", x+1.5*w, 0)
		f2pDisplay.f2ppriceframe:SetSize(w, h)
		
		f2pDisplay.f2ppriceframe.f2pButtonFSB = f2pDisplay.f2ppriceframe:CreateFontString("FontString", "OVERLAY", "GameTooltipText")
		--f2pDisplay.f2pButtonFSB:SetPoint("CENTER", f2pDisplay)
		f2pDisplay.f2ppriceframe.f2pButtonFSB:SetPoint("CENTER", f2pDisplay.f2ppriceframe)
		--f2pDisplay.f2pButtonFSB:SetPoint("BOTTOMLEFT", f2pDisplay)
		f2pDisplay.f2ppriceframe.f2pButtonFSB:SetFont("Fonts\\FRIZQT__.TTF", 14, "THINOUTLINE")
		--f2pButtonFSU:SetShadowOffset(1, -1)--Optional
		f2pDisplay.f2ppriceframe.f2pButtonFSB:SetTextColor(1, 1, 1);
			
		f2pDisplay.f2pButtonFST = f2pDisplay:CreateFontString("FontString", "OVERLAY", "GameTooltipText")
		--f2pDisplay.f2pButtonFST:SetPoint("CENTER", f2pDisplay)
		f2pDisplay.f2pButtonFST:SetPoint("TOPRIGHT", f2pDisplay)
		--f2pDisplay.f2pButtonFST:SetPoint("TOPLEFT", f2pDisplay)
		f2pDisplay.f2pButtonFST:SetFont("Fonts\\FRIZQT__.TTF", 14, "THINOUTLINE")
		--f2pButtonFST:SetShadowOffset(1, -1)--Optional
		f2pDisplay.f2pButtonFST:SetTextColor(1, 1, 1);

		f2pDisplay.f2pButtonFSB = f2pDisplay:CreateFontString("FontString", "OVERLAY", "GameTooltipText")
		--f2pDisplay:SetPoint("CENTER", f2pDisplay)
		--f2pDisplay.f2pButtonFSB:SetPoint("CENTER", f2pDisplay)
		f2pDisplay.f2pButtonFSB:SetPoint("BOTTOMRIGHT", f2pDisplay)
		--f2pDisplay.f2pButtonFSB:SetPoint("BOTTOMLEFT", f2pDisplay)
		f2pDisplay.f2pButtonFSB:SetFont("Fonts\\FRIZQT__.TTF", 14, "THINOUTLINE")
		--f2pButtonFSU:SetShadowOffset(1, -1)--Optional
		f2pDisplay.f2pButtonFSB:SetTextColor(1, 1, 1);

		f2pDisplay:Hide()
		f2pDisplay:HookScript("OnEnter", function(self)
			--print("f2pDisplay on enter")
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			--GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
			GameTooltip:SetHyperlink(itemLink)
			GameTooltip:Show()
		end)
		f2pDisplay:HookScript("OnLeave", GameTooltip_Hide)
	else
		print("trying to recreate",itemID)
	end
	

	end


local trialmoneycap = 10*100*100
local numbuybackitems
local summm
local price
local function updateCount()
	--local money = GetMoney()
	--local countbank = {}
	--local countbag = {}
	--print("I have",money,GetCoinTextureString(money))
	--f2pellbacknFS:SetText('some m oney')
	if at_vendor then
		numbuybackitems = GetNumBuybackItems()
		--print(numbuybackitems)
		summm = 0
		for index = 1, numbuybackitems do
			_, _, price = GetBuybackItemInfo(index)
			summm = summm + price
		end
		f2sellbacknFS:SetText(GetCoinTextureString(summm))
	end
	for index = 1, numIte, 1 do
		local itemID = itemset[index]
		
		local itemcount = GetItemCount(itemID, false, false)
		--print(itemID, itemcount)
		local itemcount_bank = GetItemCount(itemID, true, false)
		--print(itemID,itemcount,itemcount_bank,"updatecount")
	

		--local itemName, itemLink, _,_,_,_,_,_,_,itemTexture,_ = GetItemInfo(itemID)
		--if itemName then
		if _G["f2pDisplay"..itemID] then
			local something = _G["f2pDisplay"..itemID]
			--print("found the button")
			--print(something)
			local selltotal = itemcount*vendorprice[itemID]
			local money = GetMoney();

			something.f2ppriceframe.f2pButtonFSB:SetText(GetCoinTextureString(selltotal))
			--something.f2ppriceframe.f2pButtonFSB:SetFormattedText("%.0f", itemcount)
			if selltotal >= trialmoneycap then
				something.f2ppriceframe.f2pButtonFSB:SetVertexColor(1, 0, 0) --red
			else
				if selltotal + money >= trialmoneycap then
					something.f2ppriceframe.f2pButtonFSB:SetVertexColor(0.5, 0.5, 0.5) --grayish
				else
					something.f2ppriceframe.f2pButtonFSB:SetVertexColor(1, 1, 1) --white
				end
			end
			something.f2ppriceframe.f2pButtonFSB:Show()
			
			something.f2pButtonFSB:SetFormattedText("%.0f", itemcount)
			something.f2pButtonFSB:Show()
			something.f2pButtonFST:Hide()
			if itemcount ~= itemcount_bank then
				something.f2pButtonFST:SetFormattedText("%.0f", itemcount_bank)
				something.f2pButtonFST:Show()
			end
			
			if itemcount_bank == 0 then
				something:GetNormalTexture():SetDesaturated(true);
			else
				something:GetNormalTexture():SetDesaturated(false);
			end			
			--f2pDisplayFS:SetText("Nethershards: "..currentAmount);
			--something.f2pDisplayFSTexture:SetTexture(itemTexture)
			something:Show()
			_G["f2pDisplay"..itemID] = something
		
		--else
			--print(itemID,"wasn't found")
		end
			
	end
end

local wait = {}

local cache_writer = CreateFrame('Frame')
cache_writer:SetScript('OnEvent', function(self, event, ...)
	if event == info_received then
		-- the info is now downloaded and cached
		local itemID = ...
		if wait[itemID] then
			--print(itemID,"received")
			createoneframe(itemID)
			wait[itemID] = nil
			--print(#wait)
			if not next(wait) then 
				updateCount()
				self:UnregisterEvent(event)
				--print("cache writer")
			end --test
		end
	end
	if event == "MERCHANT_SHOW" then
		at_vendor = true
		--self:UnregisterEvent(event)
		updateCount()
	end
	if event == "MERCHANT_CLOSED" then
		at_vendor = false
	end
end)
cache_writer:RegisterEvent(info_received)
cache_writer:RegisterEvent("MERCHANT_SHOW")
cache_writer:RegisterEvent("MERCHANT_CLOSED")
local function createFrames()
	--f2pInitFrame:RegisterEvent("BAG_UPDATE_DELAYED")

	for index = 1, numIte, 1 do
		local itemID = itemset[index]
		local name = GetItemInfo(itemID)
		which[itemID] = index
		if name then
			createoneframe(itemID)
		else
			--add item to wait list
			wait[itemID] = {}
		end
	end
end	

local f2pInitFrame = CreateFrame("Frame", "f2pInitFrame", f2pDragFrame)
local init_event = "PLAYER_LOGIN"
--local init_event = "BAG_UPDATE_DELAYED"
--local init_event = "PLAYER_ENTERING_WORLD"
f2pInitFrame:RegisterEvent(init_event)
f2pInitFrame:SetScript("OnEvent", function(self, event, ...)
	if event == init_event then
		createFrames()
		self:RegisterEvent("BAG_UPDATE_DELAYED")
		self:RegisterEvent("UPDATE_FACTION")
		self:RegisterEvent("PLAYER_MONEY")
		createmoneyframe()
		createbagFrames()
		--[[
		if wait == {} then 
			updateCount()
			--print("wait")
		else
			for i in pairs(wait) do
				print(i)
			end
			print("asd")
		end
		--]]
		--[[
		if wait_bag == {} then
			updateBagCount()
			--print("wait_bag")
		else
			for i in pairs(wait_bag) do
				print(i)
			end
			print("dsa")
		end
		--]]
		self:UnregisterEvent(event)
	end
	--if event == "BAG_UPDATE" then
	if event == "BAG_UPDATE_DELAYED" or event == "UPDATE_FACTION" or event  == "PLAYER_MONEY" then
		--print("f2p init BAG_UPDATE_DELAYED")
		updateCount()
		updateBagCount()
	end
end)
