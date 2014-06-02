local Locale = {}

Locale.Default = "English"

Locale.Selected = "English"

Locale.AvailableLocales = {
	"Francais",
	"Deutsch",
	"English",
	"Espanol",
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
	for i,v in pairs(Locale.AvailableLocales) do
		if v == lang then
			local try = Instinct.Include("LocaleFiles/"..v)
			if try then
				Locale.SelectedLocale = try
				found = true
				break
			else
				print("[Instinct Core] Locale not found: "..tostring(v))
			end
		end
	end
	if not found then
		print("[Instinct Core] Locale not found: "..tostring(lang))
	end
end

return Locale