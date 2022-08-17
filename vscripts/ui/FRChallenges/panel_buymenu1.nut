global function InitArenasBuyPanel1
global function returnWeaponButtons1
global function CleanAllButtons
global function DisableAllButtons
global function EnableAllButtons
global function returnVisibleAttachmentsBox1
global function CloseAllAttachmentsBoxes

struct
{
	var menu
    var header
    var text
	bool tabsInitialized = false

	array<var> weaponButtons
	
	//attachments box	
	vector screenPos
	float xstep
	float ystep
	float ancho
	var frame1
	var frame2
	var frame3
	var frame4
	var line1
	var line2
	var line3
	var line4
	var invisibleExitButton
	var closebutton
	var savebutton
	var opticsbutton
	var opticstext
	var barrelsbutton
	var barrelstext
	var stocksbutton
	var stockstext
	var boltstext
	var boltsbutton

	array<var> visibleAttachmentsBoxElements
	
	string desiredweapon
	string weapontype
	var desiredWeaponButtonToMark
	int desiredOptic = 0
	int desiredBarrel = 0
	int desiredStock = 0
	int desiredShotgunbolt = 0
	

	array<var> SMGOptics
	array<var> SMGBarrels
	array<var> SMGStocks
	array<var> ShotgunBolts

	var magstext
	var magsbutton	
	int desiredMag = 0
	string desiredAmmoType = ""
	array<var> Mags
} file

void function InitArenasBuyPanel1( var panel )
{
	var menu = panel
	file.menu = menu

	//attachments box setup
	//background
	file.frame1 = Hud_GetChild( file.menu, "ScreenBlur" )
	file.frame2 = Hud_GetChild( file.menu, "SMGLootFrame" )
	file.frame3 = Hud_GetChild( file.menu, "SMGLootFrame2" )
	file.frame4 = Hud_GetChild( file.menu, "SMGLootFrame3" )
	file.line1 = Hud_GetChild( file.menu, "Line1" )	
	file.line2 = Hud_GetChild( file.menu, "Line2" )	
	file.line3 = Hud_GetChild( file.menu, "Line3" )	
	file.line4 = Hud_GetChild( file.menu, "Line4" )	
	//footer
	file.invisibleExitButton = Hud_GetChild( file.menu, "InvisibleExitButton" )
	AddEventHandlerToButton( menu, "InvisibleExitButton", UIE_CLICK, CloseButtonAttachmentsBox )
	AddEventHandlerToButton( menu, "InvisibleExitButton", UIE_CLICKRIGHT, CloseButtonAttachmentsBox )
	file.closebutton = Hud_GetChild( file.menu, "CloseButton" )
	AddEventHandlerToButton( menu, "CloseButton", UIE_CLICK, CloseButtonAttachmentsBox )
	file.savebutton = Hud_GetChild( file.menu, "SaveButton" )
	AddEventHandlerToButton( menu, "SaveButton", UIE_CLICK, BuyWeaponWithAttachments )
	//header
	file.opticsbutton = Hud_GetChild( file.menu, "OpticsButton" )
	file.opticstext = Hud_GetChild( file.menu, "OpticsText" )
	file.barrelsbutton = Hud_GetChild( file.menu, "BarrelsButton" )
	file.boltsbutton = Hud_GetChild( file.menu, "BoltsButton" )
	file.barrelstext = Hud_GetChild( file.menu, "BarrelsText" )
	file.stocksbutton = Hud_GetChild( file.menu, "StocksButton" )
	file.stockstext = Hud_GetChild( file.menu, "StocksText" )
	file.boltstext = Hud_GetChild( file.menu, "BoltsText" )
	file.magsbutton = Hud_GetChild( file.menu, "MagsButton" )
	file.magstext = Hud_GetChild( file.menu, "MagsText" )
	//buttons for header
	AddEventHandlerToButton( file.menu, "OpticsButton", UIE_CLICK, SMGOptics )
	AddEventHandlerToButton( file.menu, "BarrelsButton", UIE_CLICK, SMGBarrels )
	AddEventHandlerToButton( file.menu, "StocksButton", UIE_CLICK, SMGStocks )
	AddEventHandlerToButton( file.menu, "BoltsButton", UIE_CLICK, ShotgunBolts )
	AddEventHandlerToButton( file.menu, "MagsButton", UIE_CLICK, Mags )
	//SMG Optics Loadout
	file.SMGOptics.append( Hud_GetChild( file.menu, "SMGOptics6" ) )
	file.SMGOptics.append( Hud_GetChild( file.menu, "SMGOptics1" ) )
	file.SMGOptics.append( Hud_GetChild( file.menu, "SMGOptics2" ) )
	file.SMGOptics.append( Hud_GetChild( file.menu, "SMGOptics3" ) )
	file.SMGOptics.append( Hud_GetChild( file.menu, "SMGOptics4" ) )
	file.SMGOptics.append( Hud_GetChild( file.menu, "SMGOptics5" ) )
	//SMG Barrels
	file.SMGBarrels.append( Hud_GetChild( file.menu, "SMGBarrels1" ) )
	file.SMGBarrels.append( Hud_GetChild( file.menu, "SMGBarrels2" ) )
	file.SMGBarrels.append( Hud_GetChild( file.menu, "SMGBarrels3" ) )
	file.SMGBarrels.append( Hud_GetChild( file.menu, "SMGBarrels4" ) )
	//SMG Stocks
	file.SMGStocks.append( Hud_GetChild( file.menu, "SMGStocks1" ) )
	file.SMGStocks.append( Hud_GetChild( file.menu, "SMGStocks2" ) )
	file.SMGStocks.append( Hud_GetChild( file.menu, "SMGStocks3" ) )
	//Shotgun Bolts
	file.ShotgunBolts.append( Hud_GetChild( file.menu, "ShotgunBolt1" ) )
	file.ShotgunBolts.append( Hud_GetChild( file.menu, "ShotgunBolt2" ) )
	file.ShotgunBolts.append( Hud_GetChild( file.menu, "ShotgunBolt3" ) )
	file.ShotgunBolts.append( Hud_GetChild( file.menu, "ShotgunBolt4" ) )
	//Mags
	file.Mags.append( Hud_GetChild( file.menu, "Mags1" ) )
	file.Mags.append( Hud_GetChild( file.menu, "Mags2" ) )
	file.Mags.append( Hud_GetChild( file.menu, "Mags3" ) )
	file.Mags.append( Hud_GetChild( file.menu, "Mags4" ) )
		
	//Optics default
	Hud_SetSelected( file.SMGOptics[0], true )
	Hud_SetSelected( file.SMGBarrels[0], true )
	Hud_SetSelected( file.SMGStocks[0], true )
	Hud_SetSelected( file.ShotgunBolts[0], true )
	Hud_SetSelected( file.Mags[0], true )
	
	//Optics buttons
	AddEventHandlerToButton( file.menu, "SMGOptics1", UIE_CLICK, SetSMGOpticsAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGOptics2", UIE_CLICK, SetSMGOpticsAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGOptics3", UIE_CLICK, SetSMGOpticsAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGOptics4", UIE_CLICK, SetSMGOpticsAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGOptics5", UIE_CLICK, SetSMGOpticsAttachmentSelected )
	AddEventHandlerToButton( file.menu, "SMGOptics6", UIE_CLICK, SetSMGOpticsAttachmentSelected )
	
	AddEventHandlerToButton( file.menu, "SMGBarrels1", UIE_CLICK, SetSMGBarrelsAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGBarrels2", UIE_CLICK, SetSMGBarrelsAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGBarrels3", UIE_CLICK, SetSMGBarrelsAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGBarrels4", UIE_CLICK, SetSMGBarrelsAttachmentSelected )	
	
	AddEventHandlerToButton( file.menu, "SMGStocks1", UIE_CLICK, SetSMGStocksAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGStocks2", UIE_CLICK, SetSMGStocksAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "SMGStocks3", UIE_CLICK, SetSMGStocksAttachmentSelected )	

	AddEventHandlerToButton( file.menu, "ShotgunBolt1", UIE_CLICK, SetShotgunBoltAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "ShotgunBolt2", UIE_CLICK, SetShotgunBoltAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "ShotgunBolt3", UIE_CLICK, SetShotgunBoltAttachmentSelected )
	AddEventHandlerToButton( file.menu, "ShotgunBolt4", UIE_CLICK, SetShotgunBoltAttachmentSelected )

	AddEventHandlerToButton( file.menu, "Mags1", UIE_CLICK, SetMagAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "Mags2", UIE_CLICK, SetMagAttachmentSelected )	
	AddEventHandlerToButton( file.menu, "Mags3", UIE_CLICK, SetMagAttachmentSelected )
	AddEventHandlerToButton( file.menu, "Mags4", UIE_CLICK, SetMagAttachmentSelected )
		
    AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnR5RSB_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnR5RSB_Hide )

	var p2020 = Hud_GetChild( menu, "P2020" )
	RuiSetImage( Hud_GetRui( p2020 ), "basicImage", $"rui/weapon_icons/r5/weapon_p2020" )
	//AddEventHandlerToButton( menu, "P2020Button", UIE_CLICK, BuyP2020 )
	AddEventHandlerToButton( menu, "P2020Button", UIE_CLICK, OpenAttachmentsBox )
	file.weaponButtons.append(Hud_GetChild( menu, "P2020Button" ))

	var mozam = Hud_GetChild( menu, "Mozambique" )
	RuiSetImage( Hud_GetRui( mozam ), "basicImage", $"rui/weapon_icons/r5/weapon_mozambique" )
	//AddEventHandlerToButton( menu, "MozambiqueButton", UIE_CLICK, BuyMozam )
	AddEventHandlerToButton( menu, "MozambiqueButton", UIE_CLICK, OpenAttachmentsBox )
	file.weaponButtons.append(Hud_GetChild( menu, "MozambiqueButton" ))

	var wingman = Hud_GetChild( menu, "Wingman" )
	RuiSetImage( Hud_GetRui( wingman ), "basicImage", $"rui/weapon_icons/r5/weapon_wingman" )
	//AddEventHandlerToButton( menu, "WingmanButton", UIE_CLICK, BuyWingman )
	AddEventHandlerToButton( menu, "WingmanButton", UIE_CLICK, OpenAttachmentsBox )
	file.weaponButtons.append(Hud_GetChild( menu, "WingmanButton" ))

	var re45 = Hud_GetChild( menu, "RE45" )
	RuiSetImage( Hud_GetRui( re45 ), "basicImage", $"rui/weapon_icons/r5/weapon_r45" )
	//AddEventHandlerToButton( menu, "RE45Button", UIE_CLICK, BuyRE45 )
	AddEventHandlerToButton( menu, "RE45Button", UIE_CLICK, OpenAttachmentsBox )
	file.weaponButtons.append(Hud_GetChild( menu, "RE45Button" ))

	// var alternator = Hud_GetChild( menu, "Alternator" )
	// RuiSetImage( Hud_GetRui( alternator ), "basicImage", $"rui/weapon_icons/r5/weapon_alternator" )
	// AddEventHandlerToButton( menu, "AlternatorButton", UIE_CLICK, BuyAlternator )
	// AddEventHandlerToButton( menu, "AlternatorButton", UIE_CLICKRIGHT, OpenAttachmentsBox )
	// file.weaponButtons.append(Hud_GetChild( menu, "AlternatorButton" ))

	// var r99 = Hud_GetChild( menu, "R99" )
	// RuiSetImage( Hud_GetRui( r99 ), "basicImage", $"rui/weapon_icons/r5/weapon_r97" )
	// AddEventHandlerToButton( menu, "R99Button", UIE_CLICK, BuyR99 )
	// AddEventHandlerToButton( menu, "R99Button", UIE_CLICKRIGHT, OpenAttachmentsBox )
	// file.weaponButtons.append(Hud_GetChild( menu, "R99Button" ))

	var eva8 = Hud_GetChild( menu, "EVA8" )
	RuiSetImage( Hud_GetRui( eva8 ), "basicImage", $"rui/weapon_icons/r5/weapon_eva8" )
	//AddEventHandlerToButton( menu, "EVA8Button", UIE_CLICK, BuyEva8 )
	AddEventHandlerToButton( menu, "EVA8Button", UIE_CLICK, OpenAttachmentsBox )
	file.weaponButtons.append(Hud_GetChild( menu, "EVA8Button" ))
	
	var mastiff = Hud_GetChild( menu, "Mastiff" )
	RuiSetImage( Hud_GetRui( mastiff ), "basicImage", $"rui/weapon_icons/r5/weapon_mastiff" )
	//AddEventHandlerToButton( menu, "MastiffButton", UIE_CLICK, BuyMastiff )
	AddEventHandlerToButton( menu, "MastiffButton", UIE_CLICK, OpenAttachmentsBox )
	file.weaponButtons.append(Hud_GetChild( menu, "MastiffButton" ))
	
	var peacekeeper = Hud_GetChild( menu, "Peacekeeper" )
	RuiSetImage( Hud_GetRui( peacekeeper ), "basicImage", $"rui/weapon_icons/r5/weapon_peacekeeper" )
	//AddEventHandlerToButton( menu, "PeacekeeperButton", UIE_CLICK, BuyPeacekeeper )
	AddEventHandlerToButton( menu, "PeacekeeperButton", UIE_CLICK, OpenAttachmentsBox )
	file.weaponButtons.append(Hud_GetChild( menu, "PeacekeeperButton" ))
	
	CleanAllButtons()
}

array<var> function returnWeaponButtons1()
{
	return file.weaponButtons
}

array<var> function returnVisibleAttachmentsBox1()
{
	return file.visibleAttachmentsBoxElements
}

void function OnR5RSB_Hide(var panel)
{
}

void function OnR5RSB_Show(var panel)
{
}
void function CleanAllButtons()
{
	foreach(var rui in returnWeaponButtons1())
	{
		RuiSetInt( Hud_GetRui(rui), "status", eFriendStatus.OFFLINE )	
	}
	foreach(var rui in returnWeaponButtons2())
	{
		RuiSetInt( Hud_GetRui(rui), "status", eFriendStatus.OFFLINE )	
	}
	foreach(var rui in returnWeaponButtons3())
	{
		RuiSetInt( Hud_GetRui(rui), "status", eFriendStatus.OFFLINE )	
	}
	foreach(var rui in returnWeaponButtons4())
	{
		RuiSetInt( Hud_GetRui(rui), "status", eFriendStatus.OFFLINE )	
	}
	foreach(var rui in returnWeaponButtons5())
	{
		RuiSetInt( Hud_GetRui(rui), "status", eFriendStatus.OFFLINE )	
	}	
}

void function DisableAllButtons()
{
	foreach(var rui in returnWeaponButtons1())
	{
		Hud_SetEnabled( rui, false )
	}
	foreach(var rui in returnWeaponButtons2())
	{
		Hud_SetEnabled( rui, false )
	}
	foreach(var rui in returnWeaponButtons3())
	{
		Hud_SetEnabled( rui, false )
	}
	foreach(var rui in returnWeaponButtons4())
	{
		Hud_SetEnabled( rui, false )
	}
	foreach(var rui in returnWeaponButtons5())
	{
		Hud_SetEnabled( rui, false )
	}	
}

void function EnableAllButtons()
{
	foreach(var rui in returnWeaponButtons1())
	{
		Hud_SetEnabled( rui, true )
	}
	foreach(var rui in returnWeaponButtons2())
	{
		Hud_SetEnabled( rui, true )
	}
	foreach(var rui in returnWeaponButtons3())
	{
		Hud_SetEnabled( rui, true )
	}
	foreach(var rui in returnWeaponButtons4())
	{
		Hud_SetEnabled( rui, true )
	}
	foreach(var rui in returnWeaponButtons5())
	{
		Hud_SetEnabled( rui, true )
	}	
}

void function CloseAllAttachmentsBoxes()
{
	EnableBuyWeaponsMenuTabs()
	
	foreach(var rui in returnVisibleAttachmentsBox1())
	{
		Hud_SetVisible(rui, false)
	}
	foreach(var rui in returnVisibleAttachmentsBox2())
	{
		Hud_SetVisible(rui, false)
	}
	foreach(var rui in returnVisibleAttachmentsBox3())
	{
		Hud_SetVisible(rui, false)
	}
	foreach(var rui in returnVisibleAttachmentsBox4())
	{
		Hud_SetVisible(rui, false)
	}
	foreach(var rui in returnVisibleAttachmentsBox5())
	{
		Hud_SetVisible(rui, false)
	}	
	
	EnableAllButtons()
}

void function OpenAttachmentsBox( var button )
{
	CloseAllAttachmentsBoxes()
	
	bool smg = false
	bool pistol = false
	bool shotgun = false
	bool ar = false
	bool sniper = false
	bool pistol2 = false
	
	if(button == Hud_GetChild( file.menu, "P2020Button" ))
	{
		file.desiredWeaponButtonToMark = Hud_GetChild( file.menu, "P2020Button" )
		file.desiredweapon = "mp_weapon_semipistol"
		pistol2 = true
		file.weapontype = "pistol2"
	}else if(button == Hud_GetChild( file.menu, "MozambiqueButton" ))
	{
		file.desiredWeaponButtonToMark = Hud_GetChild( file.menu, "MozambiqueButton" )
		file.desiredweapon = "mp_weapon_shotgun_pistol"
		shotgun = true
		file.weapontype = "shotgun"
	}else if(button == Hud_GetChild( file.menu, "WingmanButton" ))
	{
		file.desiredWeaponButtonToMark = Hud_GetChild( file.menu, "WingmanButton" )
		file.desiredweapon = "mp_weapon_wingman"
		pistol2 = true
		file.weapontype = "pistol2"
	}else if(button == Hud_GetChild( file.menu, "RE45Button" ))
	{
		file.desiredWeaponButtonToMark = Hud_GetChild( file.menu, "RE45Button" )
		file.desiredweapon = "mp_weapon_autopistol"
		pistol = true
		file.weapontype = "pistol"
	}else if(button == Hud_GetChild( file.menu, "EVA8Button" ))
	{
		file.desiredWeaponButtonToMark = Hud_GetChild( file.menu, "EVA8Button" )
		file.desiredweapon = "mp_weapon_shotgun"
		shotgun = true
		file.weapontype = "shotgun"
	}else if(button == Hud_GetChild( file.menu, "MastiffButton" ))
	{
		file.desiredWeaponButtonToMark = Hud_GetChild( file.menu, "MastiffButton" )
		file.desiredweapon = "mp_weapon_mastiff"
		shotgun = true
		file.weapontype = "shotgun"
	}else if(button == Hud_GetChild( file.menu, "PeacekeeperButton" ))
	{
		file.desiredWeaponButtonToMark = Hud_GetChild( file.menu, "PeacekeeperButton" )
		file.desiredweapon = "mp_weapon_energy_shotgun"
		shotgun = true
		file.weapontype = "shotgun"
	}
	
	vector mousePos = GetCursorPosition()
	UISize screenSize = GetScreenSize()
	//don't try this at home
	
	file.screenPos = < mousePos.x * screenSize.width / 1920.0, mousePos.y * screenSize.height / 1080.0, 0.0 >
	file.xstep = 16.5 * (screenSize.width / 1920.0)
	file.ystep = 90 * (screenSize.height / 1080.0)
	file.ancho = 75 *  (screenSize.width / 1920.0) + file.xstep
	float attachmentsBoxancho = screenSize.width * 0.25
	float attachmentsBoxAlto = screenSize.height * 0.24
	float buttonsOffset = screenSize.width*0.15
	float buttonsOffsetTop = screenSize.width*0.0833
	float buttonsOnTopCenter = buttonsOffsetTop/2
	float TextButtonsOnTopOffset = 27 * (screenSize.width / 1920.0)
	
	int nuevoancho
	if(file.desiredweapon == "mp_weapon_autopistol")
	{
		nuevoancho = Hud_GetWidth(file.frame1)/3
		Hud_SetWidth(file.opticsbutton, nuevoancho)
		Hud_SetWidth(file.magsbutton, nuevoancho)
		Hud_SetWidth(file.barrelsbutton, nuevoancho)
		buttonsOffsetTop = screenSize.width*0.1
		buttonsOnTopCenter = buttonsOffsetTop/2
	}
	else{
		nuevoancho = Hud_GetWidth(file.frame1)/2
		Hud_SetWidth(file.opticsbutton, nuevoancho)
		Hud_SetWidth(file.magsbutton, nuevoancho)
		Hud_SetWidth(file.boltsbutton, nuevoancho)
		buttonsOffsetTop = screenSize.width*0.15
		buttonsOnTopCenter = buttonsOffsetTop/2
	}
	
	int BottomButtonsHeight = Hud_GetHeight(file.closebutton)
	Hud_SetHeight(file.frame3, BottomButtonsHeight)
	Hud_SetHeight(file.frame4, BottomButtonsHeight)
	//DisableAllButtons()
	
	
	//MENU BASICS
	//visibility for background of the mini box
	Hud_SetVisible(file.frame1, true)
	file.visibleAttachmentsBoxElements.append(file.frame1)
	Hud_SetVisible(file.frame2, true)
	file.visibleAttachmentsBoxElements.append(file.frame2)
	Hud_SetVisible(file.frame3, true)
	file.visibleAttachmentsBoxElements.append(file.frame3)
	Hud_SetVisible(file.frame4, true)
	file.visibleAttachmentsBoxElements.append(file.frame4)
	Hud_SetVisible(file.line1, true)
	file.visibleAttachmentsBoxElements.append(file.line1)
	Hud_SetVisible(file.line2, true)
	file.visibleAttachmentsBoxElements.append(file.line2)
	Hud_SetVisible(file.line3, true)
	file.visibleAttachmentsBoxElements.append(file.line3)
	Hud_SetVisible(file.line4, true)
	file.visibleAttachmentsBoxElements.append(file.line4)

	//visibility for top

	Hud_SetVisible(file.opticsbutton, true)
	file.visibleAttachmentsBoxElements.append(file.opticsbutton)
	file.visibleAttachmentsBoxElements.append(file.opticstext)
	Hud_SetVisible(file.opticstext, true)	
	
	if(!pistol2 && !shotgun){
	Hud_SetVisible(file.barrelsbutton, true)
	file.visibleAttachmentsBoxElements.append(file.barrelsbutton)
	file.visibleAttachmentsBoxElements.append(file.barrelstext)
	Hud_SetVisible(file.barrelstext, true)
	}
	
	if(!pistol2 && !pistol && !shotgun){
	Hud_SetVisible(file.stocksbutton, true)
	file.visibleAttachmentsBoxElements.append(file.stocksbutton)	
	Hud_SetVisible(file.stockstext, true)
	file.visibleAttachmentsBoxElements.append(file.stockstext)
	}
	
	if(shotgun){
		Hud_SetVisible(file.boltsbutton, true)
		Hud_SetVisible(file.boltstext, true)
		file.visibleAttachmentsBoxElements.append(file.boltsbutton)
		file.visibleAttachmentsBoxElements.append(file.boltstext)
	}
	
	if(!shotgun){
		Hud_SetVisible(file.magsbutton, true)
		Hud_SetVisible(file.magstext, true)
		file.visibleAttachmentsBoxElements.append(file.magsbutton)
		file.visibleAttachmentsBoxElements.append(file.magstext)		
	}
	
	//visibility for bottom
	Hud_SetVisible(file.invisibleExitButton, true)
	file.visibleAttachmentsBoxElements.append(file.invisibleExitButton)	
	Hud_SetVisible(file.closebutton, true)
	file.visibleAttachmentsBoxElements.append(file.closebutton)
	Hud_SetVisible(file.savebutton, true)
	file.visibleAttachmentsBoxElements.append(file.savebutton)
	
	//Position Frames
	Hud_SetPos( file.frame1, file.screenPos.x, file.screenPos.y )	
	Hud_SetPos( file.frame2, file.screenPos.x, file.screenPos.y )
	Hud_SetPos( file.frame3, file.screenPos.x, file.screenPos.y+attachmentsBoxAlto-BottomButtonsHeight )
	Hud_SetPos( file.frame4, file.screenPos.x, file.screenPos.y )
	
	//bottom
	Hud_SetPos( file.closebutton, file.screenPos.x+buttonsOffset, file.screenPos.y+attachmentsBoxAlto-BottomButtonsHeight )
	SetButtonRuiText(file.closebutton, "Close" )
	Hud_SetPos( file.savebutton, file.screenPos.x, file.screenPos.y+attachmentsBoxAlto-BottomButtonsHeight )
	SetButtonRuiText( file.savebutton, "Get Loadout" )	
	
	//top
	Hud_SetPos( file.opticsbutton, file.screenPos.x, file.screenPos.y )	
	Hud_SetSelected( file.opticsbutton, true )
	SetButtonRuiText( file.opticsbutton, "" )
	Hud_SetPos( file.opticstext, file.screenPos.x+buttonsOnTopCenter-TextButtonsOnTopOffset, file.screenPos.y )	
	
	Hud_SetPos( file.barrelsbutton, file.screenPos.x+buttonsOffsetTop, file.screenPos.y )	
	SetButtonRuiText( file.barrelsbutton, "" )
	Hud_SetPos( file.barrelstext, file.screenPos.x+(buttonsOnTopCenter*3)-TextButtonsOnTopOffset-(10* (screenSize.width / 1920.0)), file.screenPos.y )//with additional offset
	if(!shotgun && pistol){
		Hud_SetPos( file.magsbutton, file.screenPos.x+(buttonsOffsetTop*2), file.screenPos.y )	
		SetButtonRuiText( file.magsbutton, "" )
		Hud_SetPos( file.magstext, file.screenPos.x+(buttonsOnTopCenter*5)-TextButtonsOnTopOffset-(5* (screenSize.width / 1920.0)), file.screenPos.y )//with additional offset
	}	
	if(!shotgun && pistol2){
		Hud_SetPos( file.magsbutton, file.screenPos.x+(buttonsOffsetTop), file.screenPos.y )	
		SetButtonRuiText( file.magsbutton, "" )
		Hud_SetPos( file.magstext, file.screenPos.x+(buttonsOnTopCenter*3)-TextButtonsOnTopOffset-(5* (screenSize.width / 1920.0)), file.screenPos.y )//with additional offset
	}	
	Hud_SetPos( file.boltsbutton, file.screenPos.x+buttonsOffsetTop, file.screenPos.y )	
	SetButtonRuiText( file.boltsbutton, "" )
	Hud_SetPos( file.boltstext, file.screenPos.x+(buttonsOnTopCenter*3)-TextButtonsOnTopOffset-(10* (screenSize.width / 1920.0)), file.screenPos.y )//with additional offset
	
	Hud_SetPos( file.stocksbutton, file.screenPos.x+(buttonsOffsetTop*2), file.screenPos.y )	
	SetButtonRuiText( file.stocksbutton, "" )
	Hud_SetPos( file.stockstext, file.screenPos.x+(buttonsOnTopCenter*5)-TextButtonsOnTopOffset-(5* (screenSize.width / 1920.0)), file.screenPos.y )
	
	if(smg || pistol || shotgun || pistol2)
		SMGOptics(button)
}

void function CloseButtonAttachmentsBox(var button)
{
	EnableBuyWeaponsMenuTabs()
	
	foreach(var element in file.visibleAttachmentsBoxElements)
		Hud_SetVisible(element, false)
		
	EnableAllButtons()
}

void function SetSMGOpticsAttachmentSelected(var button)
{
	for(int i=0; i<file.SMGOptics.len(); i++){
		var element = file.SMGOptics[i]
		if(element != button)
			Hud_SetSelected(element, false)
		else
			file.desiredOptic = i
	}
	Hud_SetSelected(button, true)
}

void function SetShotgunBoltAttachmentSelected(var button)
{
	for(int i=0; i<file.ShotgunBolts.len(); i++){
		var element = file.ShotgunBolts[i]
		if(element != button)
			Hud_SetSelected(element, false)
		else
			file.desiredShotgunbolt = i
	}
	Hud_SetSelected(button, true)
}

void function SetSMGBarrelsAttachmentSelected(var button)
{
	for(int i=0; i<file.SMGBarrels.len(); i++){
		var element = file.SMGBarrels[i]
		if(element != button)
			Hud_SetSelected(element, false)
		else
			file.desiredBarrel = i
	}
	Hud_SetSelected(button, true)
}

void function SetSMGStocksAttachmentSelected(var button)
{
	for(int i=0; i<file.SMGStocks.len(); i++){
		var element = file.SMGStocks[i]
		if(element != button)
			Hud_SetSelected(element, false)
		else
			file.desiredStock = i
	}
	Hud_SetSelected(button, true)
}

void function SetMagAttachmentSelected(var button)
{
	for(int i=0; i<file.Mags.len(); i++){
		var element = file.Mags[i]
		if(element != button)
			Hud_SetSelected(element, false)
		else
			file.desiredMag = i
	}
	Hud_SetSelected(button, true)
}

void function SetButtonsOnTopUnselected()
{
	Hud_SetSelected(file.opticsbutton, false)
	Hud_SetSelected(file.barrelsbutton, false)
	Hud_SetSelected(file.boltsbutton, false)
	Hud_SetSelected(file.stocksbutton, false)
	Hud_SetSelected(file.magsbutton, false)
}

void function SetOtherTabsContentInvisible()
{
	foreach(var element in file.SMGOptics)
	{
		Hud_SetVisible(element, false)
		file.visibleAttachmentsBoxElements.removebyvalue(element)
	}
	foreach(var element in file.SMGBarrels)
	{
		Hud_SetVisible(element, false)
		file.visibleAttachmentsBoxElements.removebyvalue(element)
	}
	foreach(var element in file.ShotgunBolts)
	{
		Hud_SetVisible(element, false)
		file.visibleAttachmentsBoxElements.removebyvalue(element)
	}
	foreach(var element in file.SMGStocks)
	{
		Hud_SetVisible(element, false)
		file.visibleAttachmentsBoxElements.removebyvalue(element)
	}
	foreach(var element in file.Mags)
	{
		Hud_SetVisible(element, false)
		file.visibleAttachmentsBoxElements.removebyvalue(element)
	}
}

void function SMGOptics(var button)
{
	SetOtherTabsContentInvisible()
	SetButtonsOnTopUnselected()
	Hud_SetSelected(file.opticsbutton, true)

	Hud_SetVisible(file.SMGOptics[0], true)
	Hud_SetPos( file.SMGOptics[0], file.xstep+file.screenPos.x, file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGOptics[0]), "iconImage", $"rui/pilot_loadout/mods/empty_sight" )
	RuiSetInt( Hud_GetRui(file.SMGOptics[0]), "lootTier", 1 )
	file.visibleAttachmentsBoxElements.append(file.SMGOptics[0])
	
	UIPos refPos = REPLACEHud_GetPos( file.SMGOptics[0] )
	
	Hud_SetVisible(file.SMGOptics[1], true)
	Hud_SetPos( file.SMGOptics[1], refPos.x + file.ancho, file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGOptics[1]), "iconImage", $"rui/weapon_icons/attachments/hcog" )
	RuiSetInt( Hud_GetRui(file.SMGOptics[1]), "lootTier", 1 )
	file.visibleAttachmentsBoxElements.append(file.SMGOptics[1])
	
	Hud_SetVisible(file.SMGOptics[2], true)
	Hud_SetPos( file.SMGOptics[2], refPos.x + (file.ancho*2), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGOptics[2]), "iconImage", $"rui/weapon_icons/attachments/holosight" )
	RuiSetInt( Hud_GetRui(file.SMGOptics[2]), "lootTier", 1 )
	file.visibleAttachmentsBoxElements.append(file.SMGOptics[2])
	
	Hud_SetVisible(file.SMGOptics[3], true)
	Hud_SetPos( file.SMGOptics[3], refPos.x + (file.ancho*3), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGOptics[3]), "iconImage", $"rui/weapon_icons/attachments/threat_scope" )	
	RuiSetInt( Hud_GetRui(file.SMGOptics[3]), "lootTier", 4 )
	file.visibleAttachmentsBoxElements.append(file.SMGOptics[3])
	
	Hud_SetVisible(file.SMGOptics[4], true)
	Hud_SetPos( file.SMGOptics[4], refPos.x + (file.ancho*4), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGOptics[4]), "iconImage", $"rui/weapon_icons/attachments/1x_2x_variable_holosight")	
	RuiSetInt( Hud_GetRui(file.SMGOptics[4]), "lootTier", 2 )
	file.visibleAttachmentsBoxElements.append(file.SMGOptics[4])
	
	Hud_SetVisible(file.SMGOptics[5], true)
	Hud_SetPos( file.SMGOptics[5], refPos.x + (file.ancho*5), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGOptics[5]), "iconImage", $"rui/weapon_icons/attachments/hcog_bruiser" )
	RuiSetInt( Hud_GetRui(file.SMGOptics[5]), "lootTier", 2 )
	file.visibleAttachmentsBoxElements.append(file.SMGOptics[5])
	
	string ammoType = GetWeaponInfoFileKeyField_GlobalString( file.desiredweapon, "ammo_pool_type" )
	file.desiredAmmoType = ammoType
}

void function SMGBarrels(var button)
{
	SetOtherTabsContentInvisible()
	SetButtonsOnTopUnselected()
	Hud_SetSelected(file.barrelsbutton, true)
	
	Hud_SetVisible(file.SMGBarrels[0], true)
	Hud_SetPos( file.SMGBarrels[0], file.xstep+file.screenPos.x+file.ancho, file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGBarrels[0]), "iconImage", $"rui/pilot_loadout/mods/empty_laser_sight" )
	RuiSetInt( Hud_GetRui(file.SMGBarrels[0]), "lootTier", 1 )
	file.visibleAttachmentsBoxElements.append(file.SMGBarrels[0])
	
	UIPos refPos = REPLACEHud_GetPos( file.SMGBarrels[0] )
	
	Hud_SetVisible(file.SMGBarrels[1], true)
	Hud_SetPos( file.SMGBarrels[1], refPos.x + file.ancho, file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGBarrels[1]), "iconImage", $"rui/pilot_loadout/mods/laser_sight" )
	RuiSetInt( Hud_GetRui(file.SMGBarrels[1]), "lootTier", 1 )
	file.visibleAttachmentsBoxElements.append(file.SMGBarrels[1])
	
	Hud_SetVisible(file.SMGBarrels[2], true)
	Hud_SetPos( file.SMGBarrels[2], refPos.x + file.ancho*2, file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGBarrels[2]), "iconImage", $"rui/pilot_loadout/mods/laser_sight" )
	RuiSetInt( Hud_GetRui(file.SMGBarrels[2]), "lootTier", 2 )
	file.visibleAttachmentsBoxElements.append(file.SMGBarrels[2])
	
	Hud_SetVisible(file.SMGBarrels[3], true)
	Hud_SetPos( file.SMGBarrels[3], refPos.x + file.ancho*3, file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGBarrels[3]), "iconImage", $"rui/pilot_loadout/mods/laser_sight" )	
	RuiSetInt( Hud_GetRui(file.SMGBarrels[3]), "lootTier", 3 )
	file.visibleAttachmentsBoxElements.append(file.SMGBarrels[3])
}

void function Mags(var button)
{
	SetOtherTabsContentInvisible()
	SetButtonsOnTopUnselected()
	Hud_SetSelected(file.magsbutton, true)
	
	Hud_SetVisible(file.Mags[0], true)
	Hud_SetPos( file.Mags[0], file.xstep+file.screenPos.x+file.ancho, file.screenPos.y+file.ystep )
	RuiSetInt( Hud_GetRui(file.Mags[0]), "lootTier", 1 )
	file.visibleAttachmentsBoxElements.append(file.Mags[0])	
	
	UIPos refPos = REPLACEHud_GetPos( file.Mags[0] )
	
	Hud_SetVisible(file.Mags[1], true)
	Hud_SetPos( file.Mags[1], refPos.x+file.ancho, file.screenPos.y+file.ystep )
	RuiSetInt( Hud_GetRui(file.Mags[1]), "lootTier", 1 )
	file.visibleAttachmentsBoxElements.append(file.Mags[1])
	
	Hud_SetVisible(file.Mags[2], true)
	Hud_SetPos( file.Mags[2], refPos.x+(file.ancho*2), file.screenPos.y+file.ystep )
	RuiSetInt( Hud_GetRui(file.Mags[2]), "lootTier", 2 )
	file.visibleAttachmentsBoxElements.append(file.Mags[2])
	
	Hud_SetVisible(file.Mags[3], true)
	Hud_SetPos( file.Mags[3], refPos.x+(file.ancho*3), file.screenPos.y+file.ystep )
	RuiSetInt( Hud_GetRui(file.Mags[3]), "lootTier", 3 )
	file.visibleAttachmentsBoxElements.append(file.Mags[3])
	
	if(file.desiredAmmoType == "bullet")
	{
		RuiSetImage( Hud_GetRui(file.Mags[0]), "iconImage", $"rui/pilot_loadout/mods/empty_mag_straight" )
		RuiSetImage( Hud_GetRui(file.Mags[1]), "iconImage", $"rui/pilot_loadout/mods/light_mag" )
		RuiSetImage( Hud_GetRui(file.Mags[2]), "iconImage", $"rui/pilot_loadout/mods/light_mag" )
		RuiSetImage( Hud_GetRui(file.Mags[3]), "iconImage", $"rui/pilot_loadout/mods/light_mag" )	
	} else if (file.desiredAmmoType == "highcal")
	{
		RuiSetImage( Hud_GetRui(file.Mags[0]), "iconImage", $"rui/pilot_loadout/mods/empty_mag" )
		RuiSetImage( Hud_GetRui(file.Mags[1]), "iconImage", $"rui/pilot_loadout/mods/heavy_mag" )
		RuiSetImage( Hud_GetRui(file.Mags[2]), "iconImage", $"rui/pilot_loadout/mods/heavy_mag" )
		RuiSetImage( Hud_GetRui(file.Mags[3]), "iconImage", $"rui/pilot_loadout/mods/heavy_mag" )			
	} else if (file.desiredAmmoType == "special")
	{
		RuiSetImage( Hud_GetRui(file.Mags[0]), "iconImage", $"rui/pilot_loadout/mods/empty_energy_mag" )
		RuiSetImage( Hud_GetRui(file.Mags[1]), "iconImage", $"rui/pilot_loadout/mods/energy_mag" )
		RuiSetImage( Hud_GetRui(file.Mags[2]), "iconImage", $"rui/pilot_loadout/mods/energy_mag" )
		RuiSetImage( Hud_GetRui(file.Mags[3]), "iconImage", $"rui/pilot_loadout/mods/energy_mag" )			
	}
}

void function ShotgunBolts(var button)
{
	SetOtherTabsContentInvisible()
	SetButtonsOnTopUnselected()
	Hud_SetSelected(file.barrelsbutton, true)
	
	Hud_SetVisible(file.ShotgunBolts[0], true)
	Hud_SetPos( file.ShotgunBolts[0], file.xstep+file.screenPos.x+file.ancho, file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.ShotgunBolts[0]), "iconImage", $"rui/pilot_loadout/mods/empty_mag_shotgun" )
	RuiSetInt( Hud_GetRui(file.ShotgunBolts[0]), "lootTier", 1 )
	file.visibleAttachmentsBoxElements.append(file.ShotgunBolts[0])	
	
	UIPos refPos = REPLACEHud_GetPos( file.ShotgunBolts[0] )
	
	Hud_SetVisible(file.ShotgunBolts[1], true)
	Hud_SetPos( file.ShotgunBolts[1], refPos.x+file.ancho, file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.ShotgunBolts[1]), "iconImage", $"rui/pilot_loadout/mods/shotgun_mag" )
	RuiSetInt( Hud_GetRui(file.ShotgunBolts[1]), "lootTier", 1 )
	file.visibleAttachmentsBoxElements.append(file.ShotgunBolts[1])
	
	Hud_SetVisible(file.ShotgunBolts[2], true)
	Hud_SetPos( file.ShotgunBolts[2], refPos.x+(file.ancho*2), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.ShotgunBolts[2]), "iconImage", $"rui/pilot_loadout/mods/shotgun_mag" )
	RuiSetInt( Hud_GetRui(file.ShotgunBolts[2]), "lootTier", 2 )
	file.visibleAttachmentsBoxElements.append(file.ShotgunBolts[2])
	
	Hud_SetVisible(file.ShotgunBolts[3], true)
	Hud_SetPos( file.ShotgunBolts[3], refPos.x+(file.ancho*3), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.ShotgunBolts[3]), "iconImage", $"rui/pilot_loadout/mods/shotgun_mag" )	
	RuiSetInt( Hud_GetRui(file.ShotgunBolts[3]), "lootTier", 3 )
	file.visibleAttachmentsBoxElements.append(file.ShotgunBolts[3])
}

void function SMGStocks(var button)
{
	SetOtherTabsContentInvisible()
	SetButtonsOnTopUnselected()
	Hud_SetSelected(file.stocksbutton, true)
	
	Hud_SetVisible(file.SMGStocks[0], true)
	Hud_SetPos( file.SMGStocks[0], file.xstep+file.screenPos.x+file.ancho, file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGStocks[0]), "iconImage", $"rui/pilot_loadout/mods/tactical_stock" )
	RuiSetInt( Hud_GetRui(file.SMGStocks[0]), "lootTier", 1 )
	file.visibleAttachmentsBoxElements.append(file.SMGStocks[0])
	
	Hud_SetVisible(file.SMGStocks[1], true)
	Hud_SetPos( file.SMGStocks[1], file.xstep+file.screenPos.x+(file.ancho*2), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGStocks[1]), "iconImage", $"rui/pilot_loadout/mods/tactical_stock" )
	RuiSetInt( Hud_GetRui(file.SMGStocks[1]), "lootTier", 2 )
	file.visibleAttachmentsBoxElements.append(file.SMGStocks[1])
	
	Hud_SetVisible(file.SMGStocks[2], true)
	Hud_SetPos( file.SMGStocks[2], file.xstep+file.screenPos.x+(file.ancho*3), file.screenPos.y+file.ystep )
	RuiSetImage( Hud_GetRui(file.SMGStocks[2]), "iconImage", $"rui/pilot_loadout/mods/tactical_stock" )	
	RuiSetInt( Hud_GetRui(file.SMGStocks[2]), "lootTier", 3 )
	file.visibleAttachmentsBoxElements.append(file.SMGStocks[2])
}

void function BuyWeaponWithAttachments(var button)
{
	CleanAllButtons()
	EnableBuyWeaponsMenuTabs()
	RuiSetInt( Hud_GetRui( file.desiredWeaponButtonToMark ), "status", eFriendStatus.ONLINE_INGAME )
	foreach(var element in file.visibleAttachmentsBoxElements)
		Hud_SetVisible(element, false)
	EnableAllButtons()
	printt("DEBUG: desiredOptic: " + file.desiredOptic, " desiredBarrel: " + file.desiredBarrel, " desiredStock: " + file.desiredStock, " weapon type: " + file.weapontype)
	PlayerCurrentWeapon = GetWeaponNameForUI(file.desiredweapon)
	RunClientScript( "UIToClient_MenuGiveWeaponWithAttachments", file.desiredweapon, file.desiredOptic, file.desiredBarrel, file.desiredStock, file.desiredShotgunbolt, file.weapontype, file.desiredMag, file.desiredAmmoType )
}

void function BuyP2020(var button)
{
	CleanAllButtons()
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_semipistol" )
	PlayerCurrentWeapon = GetWeaponNameForUI("mp_weapon_semipistol")
}

void function BuyMozam(var button)
{
	CleanAllButtons()
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_shotgun_pistol" )
	PlayerCurrentWeapon = GetWeaponNameForUI("mp_weapon_shotgun_pistol")
}

void function BuyWingman(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_wingman" )
	PlayerCurrentWeapon = GetWeaponNameForUI("mp_weapon_wingman")
}

void function BuyRE45(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_autopistol" )
	PlayerCurrentWeapon = GetWeaponNameForUI("mp_weapon_autopistol")
}

void function BuyAlternator(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_alternator_smg" )
	PlayerCurrentWeapon = GetWeaponNameForUI("mp_weapon_alternator_smg")
}

void function BuyR99(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_r97" )
	PlayerCurrentWeapon = GetWeaponNameForUI("mp_weapon_r97")
}

void function BuyEva8(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_shotgun" )
	PlayerCurrentWeapon = GetWeaponNameForUI("mp_weapon_shotgun")
}

void function BuyMastiff(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_mastiff" )
	PlayerCurrentWeapon = GetWeaponNameForUI("mp_weapon_mastiff")
}

void function BuyPeacekeeper(var button)
{
	CleanAllButtons()	
	RuiSetInt( Hud_GetRui( button ), "status", eFriendStatus.ONLINE_INGAME )
	RunClientScript( "UIToClient_MenuGiveWeapon", "mp_weapon_energy_shotgun" )
	PlayerCurrentWeapon = GetWeaponNameForUI("mp_weapon_energy_shotgun")
}
