
-- Internet Offer Generator
-- Copyright 2015 - 2016 viluon (Andrew Kvapil), licensed under the MIT license (http://opensource.org/licenses/MIT)
-- Version 1.2

local m_rnd = math.random

local args = { ... }
local egg
local path = shell.getRunningProgram()

if #args == 0 then
	error( "  Usage:\n" .. path .. " [--enable-markdown] <output path>", 0 )
end

local markdownEnabled = ( args[ 1 ] == "--enable-markdown" and #args == 2 )
local filename = ( #args == 1 and args[ 1 ] or args[ 2 ] )

local usedNumbers = {}

local products = {
	"graphics card",
	"CPU",
	"16 GB RAM",
	"8 GB RAM",
	"harddrive",
	"2TB HDD",
	"Tablet",
	"Smartphone",
}

local productModifiers = {
	"top class",
	"Kingston",
	"nVidia",
	"AMD",
	"ATX",
	"overclocked",
	"limited edition",
	"core i9",
	"DDR4",
	"brand new",
	"flagship",
}

local productFeatures = {
	"4K streaming",
	"full-HD streaming",
	"remote connectibility",
	"SSH",
	"updates",
	"WiFi",
	"Bluetooth",
	"LTE",
	"Dual SIM",
	"USB 3.0",
	"Qualcomm Snapdragon processor",
	"DolbyDigital Surround Sound",
	"headphones",
	"LAN",
	"FireWire",
	"Thunderbird",
	"eSATA",
	"CD-ROM",
	"HDMI",
	"VGA",
	"OLED display",
	"AMOLED display",
	"Android 5.0",
	"Android 5.1",
	"iOS 7",
}

local free = {
	"*FREE*",
	"one-month FREE",
	"completely *free* of charge",
	"**free**",
}

local sales = {
	"90% OFF",
	"50% Off",
	"75% OFF",
}

local easterEggs = {
	[ "squiddev" ] = "a free all-natural British octopus with C# skills.";
	[ "exerro" ] = "a Lua maniac with a weird love for graphic libraries.";
	[ "oeed" ] = "an Australian developer with his MacBook.";
	[ "creator" ] = "a terrible childish ComputerCrafter who'll instantly ruin your life.";
	[ "bombbloke" ] = "a geeky guy who loves GIFs and is also capable of porting your Minecraft worlds and packaging stuff.";
	[ "bomb bloke" ] = "a geeky guy who loves GIFs and is also capable of porting your Minecraft worlds and packaging stuff.";
	[ "demhydraz" ] = "a Brazilian FOSS and Linux geek who likes to destructively criticize everything he is highly opinionated about (i.e. everything) but is quite a good friend.";
	[ "viluon" ] = "an evil genius, a mad scientist with programming skills at such a pro level that he caused the default level number data type \
of the Universe to overflow, setting it to negative values, and is therefore misregarded as a total asshole \
(who else would be capable of creating something like this program?). \
Really now, I am @viluon, nice to meet you. Most people say I am crazy. I am. That's about it. I like being friends with cool and smart people, so don't you ever talk to me.";

	[ "" ] = "";
}

local catchPhrases = {
	"Order yours today",
	"Order yours right now",
	"Claim this prize",
	"Don't hesitate and get yours",
}

local waysToOrder = {
	"calling 800-11-BESTBUY",
	"visiting the website www.100-percent-legit.com",
	"calling 911-I-WANT-ONE",
	"checking in on our FREE web www.all-free.com",
}

local callForTwoPack = {
	"Call 911 and introduce yourself as Antonio Murdrio to get a *second one* for FREE.",
	"Email us your credit card number, photo and other personally identifying information to registrations@steal-data.com and get a second one _Free of Charge_.",
}

local callForSpecial = {
	"Call 200-100-000 within 1 hour and get a %PRODUCT% for free!",
	"Visit www.best-store-ever.com in the following 5 minutes to receive a **FREE** %PRODUCT% with your order.",
	"Call 1234-GIMME-FREE-STUFF right now to order a %PRODUCT% absolutely *free of charge*.",
	"Order a %PRODUCT% as well and you will get a 40% extra sale on your order.",
}

local offerModifiers = {
	"Premium",
	"VIP",
	"Secret",
	"Limited",
	"One-time",
}

local authors = {
	"Google",
	"Apple",
	"Samsung",
	"Lenovo",
	"Acer",
	"Asus",
}

if not markdownEnabled and #args == 2 then
	if easterEggs[ args[ 1 ]:lower() ] then
		egg = easterEggs[ args[ 1 ]:lower() ]
	end
end

local function rnd( ... )
	local run, res = true

	while run do
		res = m_rnd( ... )

		run = false

		for i = 1, #usedNumbers do
			if usedNumbers[ i ] == res then
				run = true
			end
		end
	end

	usedNumbers[ #usedNumbers + 1 ] = res

	return res
end

local function resetRnd()
	usedNumbers = {}
end

local function generateProduct( markdown )
	local result = ""
	
	local limit = rnd( 1, 4 )
	resetRnd()
	for i = 1, limit do
		result = result .. productModifiers[ rnd( 1, #productModifiers ) ] .. " "
	end
	resetRnd()

	result = result .. products[ rnd( 1, #products ) ] .. " with "
	resetRnd()

	local limit = rnd( 1, 5 )
	resetRnd()
	for i = 1, limit do
		result = result .. ( markdown and "\n  - " or "" ) .. ( m_rnd() > 0.8 and free[ m_rnd( 1, #free ) ] .. " " or ""  ) .. productFeatures[ rnd( 1, #productFeatures ) ] .. ( markdown and "" or ( i == limit - 1 and " and " or ( i == limit and "" or ", " ) ) )
	end
	resetRnd()

	return result
end

local function generateOffer( markdown )
	local result = ""

	result = result ..
		offerModifiers[ m_rnd( 1, #offerModifiers ) ] ..
		" Offer " ..
		( m_rnd() > 0.5 and "by " or "from " ) ..
		authors[ m_rnd( 1, #authors ) ] ..
		":\n"

	--TODO: Fix the limits here
	--local limit = math.max( math.floor( math.sqrt( m_rnd( 1, 1000 ) ) / 8 ), 1 )

	local limit = m_rnd( 1, 4 )
	if limit == 2 then
		result = result .. "Dual pack of "
	elseif limit > 9 then
		result = result .. "GIGApack (" .. limit .. "!!!) of "
	elseif limit > 2 then
		result = result .. "Multipack (" .. limit .. "!) of "
	end

	for i = 1, limit do
		result = result .. ( markdown and "\n- " or "" ) .. generateProduct( markdown ) .. ( markdown and "" or ( i == limit - 1 and " and " or ( i == limit and "" or ", " ) ) )
	end

	if m_rnd() > 0.6 then
		result = result .. "\n\n" .. "Now up to " .. sales[ m_rnd( 1, #sales ) ] .. "!"
	end

	if m_rnd() > 0.6 then
		result = result .. "\n\n" .. catchPhrases[ m_rnd( 1, #catchPhrases ) ] .. " by " .. waysToOrder[ m_rnd( 1, #waysToOrder ) ] .. "."
	end

	if m_rnd() > 0.6 then
		result = result .. "\n\n" .. callForSpecial[ m_rnd( 1, #callForSpecial ) ]:gsub( "%%PRODUCT%%", generateProduct() )
	end

	if m_rnd() > 0.6 then
		result = result .. "\n\n" .. callForTwoPack[ m_rnd( 1, #callForTwoPack ) ]
	end

	if egg then
		result = result .. "\n\n" .. ( egg == easterEggs.viluon and "Includes " .. egg or ( m_rnd() > 0.5 and "Includes " .. egg or egg:sub( 1, 1 ):upper() .. egg:sub( 2, -2 ) .. " included." ) )
	end

	return result
end

term.setTextColour( colours.lightGrey )

local offer = generateOffer( markdownEnabled )

print( offer )

local f, err = fs.open( filename, "w" )
if not f then
	error( "Failed to open file ('" .. tostring( filename ) .. "') for writing: " .. tostring( err ), 0 )
end

f.write( offer )
f.close()