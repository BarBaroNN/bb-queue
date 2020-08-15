local alreadyRegisted = false

AddEventHandler("playerSpawned", function()
	if not alreadyRegisted then
		TriggerServerEvent('bb-queue:removeConnected')
		alreadyRegisted = true
	end
end)