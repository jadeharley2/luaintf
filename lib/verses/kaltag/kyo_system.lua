
kyo_starsystem = Def('kyo_starsystem','starsystem')
kyo_starsystem.location = fk_verse

main_star = Def('main_star','star')
main_star.location = kyo_starsystem


katric_planet = Def('katric_planet',{name='Rng'},'planet') 
katric_planet.location = kyo_starsystem
katric_planet.in_orbit = main_star
katric_planet.orbit_radius = 1 -- in ae

the_tower = Def('the_tower',{name='The tower'},'building')
the_tower.location = katric_planet


asteroid_field = Def('asteroid_field',{name='debree'},'asteroid_field') 
asteroid_field.location = kyo_starsystem
asteroid_field.in_orbit = main_star
asteroid_field.orbit_radius = 4 -- in ae



random_asteroid = Def('random_asteroid',{name='Met'},'asteroid') 
random_asteroid.location = kyo_starsystem
random_asteroid.in_orbit = asteroid_field
random_asteroid.orbit_radius = 0



asteroid_station = Def('asteroid_station',{name="Met-Station"},'spacestation') 
asteroid_station.location = kyo_starsystem
asteroid_station.in_orbit = random_asteroid 

asteroid_station_airlock = Def('asteroid_station_airlock','room') asteroid_station_airlock.location = asteroid_station
asteroid_station.airlock = asteroid_station_airlock



freespace_station = Def('freespace_station',{name="FS-Station"},'spacestation') 
freespace_station.location = kyo_starsystem
freespace_station.in_orbit = main_star 

freespace_station_airlock = Def('freespace_station_airlock','room') freespace_station_airlock.location = freespace_station
freespace_station.airlock = freespace_station_airlock




torus_station = Def('torus_station',{name="R-Station"},'spacestation')  
torus_station.location = kyo_starsystem
torus_station.in_orbit = katric_planet

station_airlock = Def('station_airlock',{name='docking port'},'room') station_airlock.location = torus_station
station_habitat = Def('station_habitat',{name='habitat'},'room') station_habitat.location = torus_station
station_laboratory = Def('station_laboratory',{name='laboratory'},'room') station_laboratory.location = torus_station
station_hub = Def('station_hub',{name='hub'},'room') station_hub.location = torus_station
station_space_elevator_entrance = Def('station_space_elevator_entrance',{name='space elevator space hub'},'room') station_space_elevator_entrance.location = torus_station

--station_habitat.image = '/img/background/3973946.webp'
 

MakeRelation(station_hub,station_airlock,direction_east)
MakeRelation(station_hub,station_habitat,direction_west)
MakeRelation(station_hub,station_space_elevator_entrance,direction_north)
MakeRelation(station_hub,station_laboratory,direction_south)

torus_station.airlock = station_airlock




tower_ground_floor = Def('tower_ground_floor',{name='tower ground floor hub'},'room') tower_ground_floor.location = the_tower
tower_entrance = Def('tower_entrance',{name='tower entrance hall'},'room') tower_entrance.location = the_tower


tower_plaza = Def('tower_plaza',{name='tower plaza'},"room") tower_plaza.location = katric_planet

MakeRelation(tower_ground_floor,tower_entrance,direction_south)
MakeRelation(tower_entrance,tower_plaza,direction_south)
--MakeRelation(station_hub,station_laboratory,direction_south)



space_elevator = Def('space_elevator','elevator')
space_elevator:add_stop('station',station_space_elevator_entrance,direction_south)
space_elevator:add_stop('ground',tower_ground_floor,direction_south)
space_elevator:set_path({'station','ground'},false,4)

