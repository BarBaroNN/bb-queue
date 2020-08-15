Config = {}

local Prefix = "[barbaroNNs Queue] "
Config.License = "" -- Enter your license key here.
Config.ServerName = "" -- Enter your server name.
Config.DiscordServerID = 1111111111111111 -- Change To Your Server ID
Config.DiscordBotToken = "CHANGEME" -- Discord Bot Token. You can create one on https://discord.com/developers/applications
Config.ApiLink = "" -- If you are using API.
Config.ApiKey = ""
Config.maxServerSlots = 1
Config.Roles = {
	Example = {
		roleID = "111111111111111111",
		points = 10,
		name = "Staff Member"
	},

	Example2 = {
		roleID = "222222222222222222",
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
