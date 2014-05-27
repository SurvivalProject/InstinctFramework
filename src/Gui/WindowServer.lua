local WindowServer = {}

WindowServer.Windows = {}

function WindowServer.Notify(Window, StateChange)
	
end

function WindowServer.RequestOpen(WindowName)
	if WindowServer.Windows[WindowName] then
		WindowServer.Windows[WindowName]:Open()
	else
		local new = Instinct.Create(Instinct.Gui.Window)
		new:Create()
		new:SetTitle(WindowName)
		WindowServer.Windows[WindowName] = new
	end
	for i,v in pairs(WindowServer.Windows) do
		if i ~= WindowName then
			v:Close()
			print("CLOSING")
		end
	end
end

return WindowServer