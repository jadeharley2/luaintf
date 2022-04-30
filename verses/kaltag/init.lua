

fk_verse = Def('fk_verse',{name="Fluff Kevlar Universe"},'universe')


year = 16510
epoch = 'SST'




Include('defines.lua')

Include('spacestation.lua')
Include('spaceship.lua')

Include('characters.lua')
Include('kyo_system.lua')
Include('flagship.lua')

Include('spellbook.lua')




















this_mirror = Def('this_mirror',{name='Mirror'},'mirror')
this_mirror.location = quarters
spell_book.location = quarters


ara.location = bridge
srk.location = bridge
zta.location = bridge
tvk.location = bridge
vst.location = bridge

vikna.location = bridge
nytro.location = quarters
zofie.location = quarters
ayn.location = quarters

katric_capital_ship.srk = srk

lia.location = hangar
twix.location = hangar
kesis.location = hangar
radoslav.location = hangar





person:response("does Kaltag happen to be one of those Dystopian MegaCorps who basically control every aspect of people's lives and is even bigger then the government?",function(s,t) 
    if s:is('anthroid') then
        s:say([[No, I.H.Kaltag is not beyond Katrician rules and laws]])
        s:say([[The Empire of Katric is very large, and often times the large sovereigns have one or more major military or technology suppliers]])
        s:say([[So in a manner of speaking, Kaltag is a sidekick to the Imperial throne of Katric, one of their longest running partners]])
        s:say([[Kaltag has many subsidiaries but they hold no political sway or power]]) 
    end
end)



print(L"This is [!ayn] and [their] gender is [gender]. [they] [are] [mood]")
print(L"This is [!nytro] and [their] gender is [gender]. [they] [are] [mood]")
print(L"This is mute[!nytro;] example: [their] gender is [gender]. But[!ayn;] [they] [are] [mood]")





zta.task = Task('follow',ara)



Include('memory.lua')