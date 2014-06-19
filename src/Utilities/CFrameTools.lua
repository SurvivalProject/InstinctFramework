local CFrameTools = {}

local acos=math.acos
local v3=Vector3.new
local components=CFrame.new().components
local inverse=CFrame.new().inverse
local fromAxisAngle=CFrame.fromAxisAngle

function CFrameTools:AxisAngleInterpolate(c0,c1,t)--CFrame0,CFrame1,Tween
	local _,_,_,xx,yx,zx,xy,yy,zy,xz,yz,zz=components(inverse(c0)*c1)
	local c=(xx+yy+zz-1)/2
	return c0*fromAxisAngle(v3(yz-zy,zx-xz,xy-yx),acos(c>1 and 1 or c<-1 and -1 or c)*t)+(c1.p-c0.p)*t
end


return CFrameTools