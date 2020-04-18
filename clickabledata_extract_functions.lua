-- Define global class type for clickabledata.
class_type = 
{
	NULL   = 0,
	BTN    = 1,
	TUMB   = 2,
	SNGBTN = 3,
	LEV    = 4
}

-- Mock out the get_option_value and get_aircraft_type functions that don't exist in this environment.
function get_option_value(x)
	return nil
end

-- Protect against relative path "dofile" calls by inspecting paths before running.
-- All should use the configured "LockOn_Options.script_path" variable.
call_dofile = dofile
function inspect_and_dofile(path)
	local is_absolute_path = (string.match(path, "DCS") and string.match(path, "World"))
	if is_absolute_path then
		call_dofile(path)
	else

		call_dofile(dcs_install_path .. path)
	end
end
--Overwrite function so any dofile function calls by module scripts will go through inspect first.
dofile = inspect_and_dofile

-- Function to get length of a table
function len(table)
	local count = 0
    for _ in pairs(table) do
	    count = count + 1
	end
	return count
end

-- Function to safely get device name, default return of "".
function get_device_name(device_id)
    device_name = ""
	for device,id in pairs(devices) do
		if (id == device_id) then
			if (device ~= nil) then
				device_name = device
			end
		end
    end
    return device_name
end

-- Conversion from class number to enum label.
function get_class_enum_label(class)
	if class == 0 then
		return "NULL"
	elseif class == 1 then
		return "BTN"
	elseif class == 2 then
		return "TUMB"
	elseif class == 3 then
		return "SNGBTN"
	elseif class == 4 then
		return "LEV"
	else
		return ""
	end
end

-- Function to safely get index of a table, default return of "".
function get_index_value(table, index)
	if (table ~= nil) then
        value = table[index]
        if (value ~= nil) then
            return value
        end
	end
	return ""
end

--[
-- Function will extract attributes for each clickabledata item from the elements table generated from the
-- clickabledata.lua script.
--
-- return: collect_element_attributes  A table of elements with their attributes
--]
function collect_element_attributes(elements)
	collected_element_attributes = {}
	local count = 0
	for element_id,_ in pairs(elements) do
		local element_name = element_id
		local hint = elements[element_id].hint
		local classes = elements[element_id].class
		local args = elements[element_id].arg
		local arg_values = elements[element_id].arg_value
		local arg_lims = elements[element_id].arg_lim
		local device_id = elements[element_id].device
		local device_name = get_device_name(device_id)
		local command_ids = elements[element_id].action
		
		-- Iterate through classes
		for idx,class in pairs(classes) do
			local class_name = get_class_enum_label(class)
			local command_id = get_index_value(command_ids,idx)
			local arg = get_index_value(args,idx)
			local arg_value = get_index_value(arg_values,idx)
			local arg_lim = get_index_value(arg_lims,idx)
			local arg_lim1 = ""
			local arg_lim2 = ""
			if (arg_lim ~= nil) then
				if (type(arg_lim) == "table") then
					arg_lim1 = arg_lim[1]
					arg_lim2 = arg_lim[2]
					-- Repeat this for further nesting (found in JF-17)
					if (type(arg_lim1) == "table") then
						arg_lim = arg_lim1
						arg_lim1 = arg_lim[1]
						arg_lim2 = arg_lim[2]
					end
				elseif (type(arg_lim) == "number") then
					arg_lim1 = arg_lim
				end
            end
            if (device_id == nil) then
                device_id = "" 
            end
            count = count + 1
            collected_element_attributes[count] = string.format("%s(%s),%s,%s,%s,%s,%s,%s,%s,%s",
                device_name, device_id, command_id, element_name, class_name, arg, arg_value, arg_lim1, arg_lim2, hint)
		end
	end
	return collected_element_attributes
end


--[
-- Function handles variations between module directories and aircraft variants within modules and runs the module's
-- clickabledata.lua script wihtin its Cockpit directory.
--
-- return: element_list  A table of strings, where each string is a comma-separated definition of a clickabledata item.
--]
function load_module(dcs_install_path, module_name)
	LockOn_Options = {}

	-- Specialty case handling for odd multi-version modules.
	if string.match(module_name,"C-101") then
		LockOn_Options.script_path = dcs_install_path..[[\Mods\aircraft\C-101\Cockpit\]]..module_name..[[\]]
	elseif string.match(module_name,"L-39") then
		L_39ZA = string.match(module_name, "L-39ZA")
		LockOn_Options.script_path = dcs_install_path..[[\Mods\aircraft\L-39C\Cockpit\]]
		dofile(LockOn_Options.script_path.."devices.lua")
	else
		LockOn_Options.script_path = dcs_install_path..[[\Mods\aircraft\]]..module_name..[[\Cockpit\]]
	end

	file_loaded = loadfile(LockOn_Options.script_path.."clickabledata.lua")
	if file_loaded == nil then
		LockOn_Options.script_path = LockOn_Options.script_path..[[Scripts\]]
		file_loaded = loadfile(LockOn_Options.script_path.."clickabledata.lua")
	end

	file_loaded()
	
	element_list = collect_element_attributes(elements)
	return element_list
end
