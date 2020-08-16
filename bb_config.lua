Config = {}

local Prefix = "[barbaroNNs Queue] "
Config.DiscordServerID = 123123123 -- Discord Server ID
Config.DiscordBotToken = "TOKEN" -- Discord Bot Token. You can create one on https://discord.com/developers/applications
Config.ApiLink = "" -- API Stuff
Config.ApiKey = ""-- API Stuff
Config.maxServerSlots = 32

Config.Roles = {
	Example = {
		roleID = "123123123123",
		points = 10,
		name = "Staff Member"
	},

	Example2 = {
		roleID = "123123123123",
		points = 15,
		name = "Donator"
	},
}

Config.Colors = {
	"accent",
	"good",
	"warning",
	"attention",
}

Config.Verifiying = Prefix .. "Please wait, Downloading content from RealisticLifeRP database."
Config.VerifiyingLauncher = Prefix .. "Please wait, Verifiying you entered through the launcher."
Config.VerifiyingDiscord = Prefix .. "Please wait, Verifiying your Discord ID."
Config.VerifiyingSteam = Prefix .. "Please wait, Verifiying your Steam."
Config.VerifiyingQueue = Prefix .. "Please wait, Adding you to the queue."

Config.NotWhitelisted = Prefix .. "Sorry, I didn't find you in our database."
Config.NoDiscord = Prefix .. "Please make sure your Discord is open."
Config.NoSteam = Prefix .. "Please make sure your Steam is open."
Config.NoLauncher = Prefix .. "The server can only be accessed through its launcher."
Config.Blacklisted = Prefix .. "You're blacklisted from the server, fuck off please."

Config.Welcome = Prefix .. "Welcome Sir."
Config.Error = Prefix .. "Error, Please try again later."
Config.HandshakingWith = Prefix .. "Handshaking With barbaroNNs Queue."
