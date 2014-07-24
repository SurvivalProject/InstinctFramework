-- ResourceContextService;
-- Main features are to build up a context list of all resources 
-- This context has all kind of data on 
-- environment temperature; resource data; 
-- type; etc. 

-- Feeding: 

-- Context \ 
			-----> ResourceContext ----> CraftService --> Crafts
-- Resource /

local ResourceContextService = {}
 

function ResourceContextService:AddContextPreset(preset, name)

end 

function ResourceContextService:GetContextPreset(name)

end 



return ResourceContextService
