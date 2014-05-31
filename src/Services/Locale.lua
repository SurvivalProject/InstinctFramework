local Locale = {}

Locale.Default = "English"

Locale.Selected = "English"

Locale.AvailableLocales = {
	"Français",
	"Deutsch",
	"English",
	"Español",
	"Italiano",	
	"Nederlands",
}

Locale.DefaultLocale = Instinct.Include("LocaleFiles/"..Locale.Default)
Locale.SelectedLocale = Locale.DefaultLocale

function Locale.Get(str)
	-- BOOM TRANSLATIONS <3
	return Locale.SelectedLocale[str] or Locale.DefaultLocale or (str..">MISSING!")
end

function Locale.Set(lang)
	local found = false
	for i,v in pairs(self.AvailableLocales) do
		if v == lang then
			local try = Instinct.Include("LocaleFiles/"..v)
			if try then
				self.SelectedLocale = try
				found = true
				break
			else
				print("[Instinct Core] Locale not found: "..v)
			end
		end
	end
	if not found then
		print("[Instinct Core] Locale not found: "..v)
	end
end

return Locale