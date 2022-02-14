
---primeri ska


bool = true
number = 1
string = 'fir'
func = function(b,l,a) print(b,l,a) end
table = {}--2 vida (na samom dele 1)

table_kak_massiv_ili_array = {1,2,3,4,5,6,7,'lol',9,10}

table_kak_slovar = {
    ska = 1,
    ble = 'ble',
    funkciya = function(heh)
        return heh*heh
    end,
}

--uzat tablici prosto

print(table_kak_slovar.funkciya(30))

Models = {
    ["models/radio/ra_domestic_dish.mdl"] = {},
    ["models/radio/ra_large_drum.mdl"] = {},
    ["models/radio/ra_large_omni.mdl"] = {},
    ["models/radio/ra_log.mdl"] = {},
    ["models/radio/ra_orbital_dish.mdl"] = {},
    ["models/radio/ra_panel.mdl"] = {},
    ["models/radio/ra_sector.mdl"] = {},
    ["models/radio/ra_small_drum.mdl"] = {},
    ["models/radio/ra_small_omni.mdl"] = {},
    ["models/radio/ra_uplink_dish.mdl"] = {},
    --[ ] nuzhni chtobi mojno bilo lubie simvoli(и даже любые значения) юзать как ключ
    --типо я не могу вот так написать ключ
    --ska kluch = 3 --шибка  '}' expected (to close '{' at line 312) near 'kluch'
    --надо вот так 
    ["ska kluch"] = 3
}

fir = 0









--primer L

local a = 1
local b = 2

local test1 = L"nam nado sdelat [a] + [b] = [a+b] vot tak da"

local test2 = LF"a vot eto delaet funkciu vmesto vozvrata stroki srazu [self.a*self.b] aga"

local rezultat = test2({a=33,b=44})
local rezultat2 = test2({a=11,b=44})
local rezultat3 = test2({a=3,b=44})
local ostanovis = 0