local anthroids = {ara,srk,vst,tvk,zta}
local anthro = {vikna,nytro,ayn}
for k,v in pairs(anthroids) do
    v.mind:knows(anthroids,'name')
    v.mind:knows(anthro,'name')
    v.mind:make_fully_known(katric_capital_ship)
    
end
for k,v in pairs(anthro) do
    v.mind:knows(anthro,'name')
    v.mind:knows(anthroids,'name')
end
 