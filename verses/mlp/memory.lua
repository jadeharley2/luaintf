
local mane6 = List{twilight,fluttershy,applejack,rarity,rainbow,pinkie}
local royal = List{celestia,luna,cadance} 
local mage3 = List{trixie,sunset,starlight} 

celestia.mind:knows(royal+twilight+sunset,"name")
celestia.mind:make_fully_known(canterlot)

luna.mind:knows(royal+twilight,"name")
luna.mind:make_fully_known(canterlot)


twilight.mind:knows(royal+mane6+mage3,"name")
fluttershy.mind:knows(royal+mane6,"name")
applejack.mind:knows(royal+mane6,"name")
rarity.mind:knows(royal+mane6,"name")
rainbow.mind:knows(royal+mane6,"name")
pinkie.mind:knows(royal+mane6,"name")


trixie.mind:knows(royal+mane6+twilight+mage3,"name")
sunset.mind:knows(royal+twilight+mage3,"name")
starlight.mind:knows(royal+twilight+mage3,"name")