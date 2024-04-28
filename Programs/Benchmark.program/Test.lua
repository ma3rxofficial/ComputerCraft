local RESULT={}

local Version={
	Matrix="0.1.7",
	Library="0.2.1",
}

local function s() --TODO SOLVE THIS!!!!!!!!!!!!!!!!!!!!!!!
	local t,e=tostring({}),nil
	os.queueEvent(t)
	while t~=e do
		e=coroutine.yield()
	end
end 

local TaskList={}

local Test={}
--[[Test.SetResultTable=function(t)
	if type(t)~="table" then error("(1)Expected table, got "..type(t)..".",2) end
	RESULT=t
	return true
end]]

Test.New=function(name,g,max,maxt,yield,fn,...) --test name,group,maximum calls of the benchmarked function,maximum time for benchmark,whether to yield or not,benchmarked function/coroutine,benchmarked function arguments
	if type(name)~="string" then error("(1)Expected string as 'name'.",2) end
	if type(max)~="number" or max<1 then error("(3)Expected number greater than 1.",2) end
	g=g or "Graphics"
	maxt=maxt/100--maxt is in seconds, convert to 1/100 of its value for easy comparison with os.time() (better than converting os.time() on every single comparison)
	if yield==nil then yield=true end
	
	local n={} --new (instance)
	local st,t,r=0,0,false --start time,time,running
	local calls=0 --actual b. function calls successfully performed
	--TODO/WARN loops completed or function calls? (diff. position)
	
	local args={...}
	if type(fn)~="function" and type(fn)~="thread" then
		error("(5)Expected function or thread, got "..type(fn)..".",2)
	end
	
	local fix=false
	
	local function Start()
		if fix then st=os.time() end
		for i=1,max do
			if type(fn)=="thread" then
				if coroutine.status(fn)=="dead" then error("Coroutine died during test execution!",2) end
				coroutine.resume(fn,unpack(args))
			else
				fn(unpack(args)) --TODO different arguments to Run(...) pass here (/comment related) WARN was Start(...) before
			end
			if yield then s() end --TODO/WARN: Also via argument? WARN coroutine!!!!!!
			calls=i
			if os.time()-st>maxt then break end --TODO/WARN > or >=?
		end
	end

	local function Stop()
		if r then
			t=os.time()-st
			r=false
		end
	end

	n.Run=function(bDoReturnCoroutine)
		term.setTextColor(colors.blue)
		print(name)
		if TaskList[name] then 
			if r then error("Test already running",2)end --WARN 'not' deleted (what it was doing there?)
			r=true                                       --WARN now it isnt possible to encouter an already running test
			st=os.time()
			if bDoReturnCoroutine then
				fix=true 
				return coroutine.create(Start)
			end
			Start()                                 --TODO/DONE? rename the functions, "Start" actually runs the test, Stop is kinda useless...
		end
		return n.End()
	end
	
	n.Running=function()
		return r
	end

	n.OnGetResults=0 --WARN highly EXPERIMENTAL

	n.GetResults=function()
		if r then error("Cannot fetch results of an ongoing test",2) end
		local out={["g"]=g,["calls"]=calls,["time"]=t,["mark"]=Test.GetMark(t,calls)}
		if type(n.OnGetResults)=="function" then -----<<<--WARN untested feature
			local values={pcall(n.OnGetResults(t,g))}
			if values[1]==true then
				table.remove(values,1) 
				out["custom"]=values
			end
		end
		return out
	end	

	n.GetName=function()return name end

	n.Rename=function(nm)
		if type(nm)~="string" then error("Expected string as 'name'",2)end
		name=nm return true
	end 

	n.End=function()
		Stop()
		if type(RESULT)~="table" then error("(!)The result table pointer was not set, unable to log test results.",2)end --WARN useless now?
		local old=RESULT[name]
		RESULT[name]=n.GetResults()
		return old,RESULT
	end

	return n

end

Test.GetResults=function()
	return RESULT
end
Test.Version=Version

Test.GetMark=function(t,c) --time,calls
	return c/t  --the bigger the better
end

Test.Convert=function(str)
	
end

Test.SetTaskList=function(tsk)
	if type(tsk)~="table" then error("(1)Expected table as TaskList, got "..type(tsk),2) end
	TaskList=tsk
end

_G.Test=Test

--[[

TODO
-point system, a way to evaluate









]]