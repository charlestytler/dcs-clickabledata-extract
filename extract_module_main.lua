-- Instructions:
-- Specify DCS Installation path and module to extract below
dcs_install_path = [[C:\Program Files\Eagle Dynamics\DCS World OpenBeta]]
module_name = "A-10C"

-- Modules:
-- A-10C, A-4E-C, AJS37, AV8BNA, Bf-109K-4, C-101CC, C-101EB, Christen Eagle II,
-- F-16C, F-5E, F-86, F14, FA-18C, FW-190A8, FW-190D9, I-16, JF-17, Ka-50,
-- L-39C, L-39ZA, M-2000C, MIG-21bis, Mi-8MTV2, MiG-15bis, MiG-19P, Mi-24P, 
-- MosquitoFBMkVI, P-47D-30, P-51D, SA342, SpitfireLFMkIX, Su-25T, Su-33, 
-- TF-51D, Uh-1H, UH-60L, Yak-52

-- End of user configurable data

-- Include functions needed to extract data
dofile("clickabledata_extract_functions.lua")

list = load_module(dcs_install_path, module_name)
table.sort(list)

-- Write extracted clickabledata elements to a CSV file
local csv_file = io.open(module_name .. "_clickabledata.csv", "w")
header = "Device (ID),Command ID,Element ID,Class Type,Arg ID,Value,Limit Min,Limit Max,Hints\n"
csv_file:write(header)
for _,row in pairs(list) do
	csv_file:write(row .. "\n")
end
