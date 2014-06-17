local Date = {}

Date.Constants = {
	millisecond = 0.001,
	second = 1,
	minute = second * 60,
	hour = minute * 60,
	day = hour * 24,
	week = day * 7,
	year = day * 365,
	lyear = day * 366,
	lsyear = day * 366 + second,
	syear = day * 365,
}

Date.Months = {
	{"Jan", 31}, {"Feb", 28},
	{"Mar", 31}, {"Apr", 30},
	{"May", 31}, {"Jun", 31},
	{"Jul", 31}, {"Aug", 30},
	{"Sep", 31}, {"Oct", 30},
	{"Nov", 31}, {"Dec", 30}	
}

Date.Start = 30 * Date.Constants.year + 7 * Date.Constants.day -- 2000 start

function Date.YearIsLeap(year) -- a full year
	return (year % 4) == 0
end

function Date.UnixToDate(time)
	local time = math.floor( ( time or os.time() ) + 0.5)
	-- 1 january 1970 00:00:00 -> 0
	local from2000 = time - Date.Start
	
	local yearsleft = from2000 % ( Date.Constants.year	)
	from2000 = from2000 - yearsleft * Date.Constants.year
	
	
end

return Date