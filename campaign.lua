function endor()
    P2_deck_cards[0] = {'Tokkat',60,4}
    P2_deck_cards[1] = {'Paploo',60,4}
    P2_deck_cards[2] = {'Wicket W Warrick',60,4}
    P2_deck_cards[3] = {'Teebo',60,4}
    P2_deck_cards[4] = {'Chief Chirpa',60,4}
    P2_deck_cards[5] = {'Logray',60,4}
    P2_deck_cards[8] = {'Ewok Elder',60,4}
    P2_deck_cards[9] = {'Ewok Scout',60,4}

    gStateMachine:change('GameState',{'Endor', 'photo', 0, 1, 1 ,1, 'Imperial March Duet.mp3'})
end

function mosEisley()
    P2_deck_cards[0] = {'Jabba The Hutt',60,4}
    P2_deck_cards[1] = {'Bib Fortuna',60,4}
    P2_deck_cards[2] = {'Old Ben Kenobi',60,4}
    P2_deck_cards[3] = {'Gamorrean Guard',60,4}
    P2_deck_cards[4] = {'C-3PO',60,4}
    P2_deck_cards[5] = {'Jawa',60,4}
    P2_deck_cards[6] = {'Dathcha',60,4}
    P2_deck_cards[7] = {'Dr Evazan',60,4}
    P2_deck_cards[8] = {'R2-D2',60,4}
    P2_deck_cards[9] = {'Greedo',60,4}
    P2_deck_cards[10] = {'Ponda Baba',60,4}
    P2_deck_cards[11] = {'Chief Nebit',60,4}
    P2_deck_cards[12] = {'Sand Trooper',60,4}
    P2_deck_cards[13] = {'Han Solo',60,4}
    P2_deck_cards[14] = {'Farmboy Luke Skywalker',60,4}
    P2_deck_cards[15] = {'Tusken Raider',60,4}
    P2_deck_cards[16] = {'Chewbacca',60,4}
    P2_deck_cards[17] = {'Imperial Stormtrooper',60,4}
    
    if Settings['videos'] then
        gStateMachine:change('GameState',{'Sand Dunes', 'video', 2, 0, 0, 0, 'Binary Sunset.oga'})
    else
        gStateMachine:change('GameState',{'Sand Dunes', 'photo', 0, 0, 0, 0, 'Binary Sunset.oga'})
    end
end

function mosEspa()
    P2_deck_cards[0] = {'Garsa Fwip',60,4}
    P2_deck_cards[1] = {'Tusken Chieftain',60,4}
    P2_deck_cards[2] = {'Nightwind Assassin',60,4}
    P2_deck_cards[3] = {'Tusken Warrior',60,4}
    P2_deck_cards[4] = {'Gamorrean Guard',60,4}
    P2_deck_cards[5] = {'Jawa',60,4}
    P2_deck_cards[6] = {'Darksaber Din Djarin',60,4}
    P2_deck_cards[7] = {'Grogu',60,4}
    P2_deck_cards[8] = {'Cad Bane BOBF',60,4}
    P2_deck_cards[9] = {'Cobb Vanth',60,4}
    P2_deck_cards[10] = {'Drash',60,4}
    P2_deck_cards[11] = {'Black Krssantan',60,4}
    P2_deck_cards[12] = {'Pyke Syndicate Soldier',60,4}
    P2_deck_cards[13] = {'Fennec Shand',60,4}
    P2_deck_cards[14] = {'Scorpenek Droid',60,4}
    P2_deck_cards[15] = {'Daimyo Boba Fett',60,4}
    P2_deck_cards[16] = {'Tusken Raider',60,4}
    P2_deck_cards[17] = {'Peli Motto',60,4}
    
    if Settings['videos'] then
        gStateMachine:change('GameState',{'Sand Dunes', 'video', 2, 0, 0, 0, 'Throne Room.oga'})
    else
        gStateMachine:change('GameState',{'Sand Dunes', 'photo', 0, 0, 0, 0, 'Throne Room.oga'})
    end
end

function throneRoom()
    P2_deck_cards[1] = {'Royal Guard',60,4}
    P2_deck_cards[2] = {'Emperor Palpatine',60,4}
    P2_deck_cards[3] = {'Darth Vader',60,4}
    P2_deck_cards[4] = {'Royal Guard',60,4}
   
    gStateMachine:change('GameState',{'Death Star Control Room', 'photo', 0, 1, 1 ,1, 'Imperial March Piano.oga'})
end

function kamino()
    P2_deck_cards[0] = {'Echo',60,4}
    P2_deck_cards[1] = {'AZI',60,4}
    P2_deck_cards[2] = {'Hunter',60,4}
    P2_deck_cards[3] = {'Vice Admiral Rampart',60,4}
    P2_deck_cards[4] = {'Taun We',60,4}
    P2_deck_cards[5] = {'Commander Cody',60,4}
    P2_deck_cards[6] = {'ARC Trooper',60,4}
    P2_deck_cards[7] = {'Clone Commando',60,4}
    P2_deck_cards[8] = {'Wrecker',60,4}
    P2_deck_cards[9] = {'Clone Commando Scorch',60,4}
    P2_deck_cards[10] = {'Clone Commando Gregor',60,4}
    P2_deck_cards[11] = {'Elite Squad Trooper',60,4}
    P2_deck_cards[12] = {'Omega',60,4}
    P2_deck_cards[13] = {'Phase 2 Clone Trooper',60,4}
    P2_deck_cards[14] = {'Crosshair',60,4}
    P2_deck_cards[15] = {'501st Clone Trooper',60,4}
    P2_deck_cards[16] = {'Kamino Training Droid',60,4}
    P2_deck_cards[17] = {'Grand Moff Tarkin',60,4}

    gStateMachine:change('GameState',{'Kamino', 'photo', 0, 1, 1 ,1, 'Clone Wars Theme.oga'})
end

function geonosis()
    for i=0,203 do
        P2_deck_cards[i] = {'B1 Battle Droid',60,4}
    end


    for i=0,35 do
        P2_deck_cards[i] = {'B2 Super Battle Droid',60,4}
    end

    P2_deck_cards[36] = {'B2-RP Super Battle Droid',60,4}
    P2_deck_cards[37] = {'Droideka Sniper',60,4}
    P2_deck_cards[38] = {'Hailfire Droid',60,4}
    P2_deck_cards[39] = {'Hailfire Droid',60,4}
    P2_deck_cards[40] = {'Droideka Sniper',60,4}
    P2_deck_cards[41] = {'B2-RP Super Battle Droid',60,4}
    
    for i=42,59 do
        P2_deck_cards[i] = {'Geonosian Brood Alpha',60,4}
    end

    for i=60,65 do
        P2_deck_cards[i] = {'Droideka',60,4}
    end

    for i=84,89 do
        P2_deck_cards[i] = {'Crab Droid',60,4}
    end

    P2_deck_cards[90] = {'Dwarf Spider Droid',60,4}
    P2_deck_cards[91] = {'Dwarf Spider Droid',60,4}
    P2_deck_cards[92] = {'Octuptarra Droid',60,4}
    P2_deck_cards[93] = {'Octuptarra Droid',60,4}
    P2_deck_cards[94] = {'Dwarf Spider Droid',60,4}
    P2_deck_cards[95] = {'Dwarf Spider Droid',60,4}

    P2_deck_cards[200] = {'Tactical Droid',60,4}
    P2_deck_cards[201] = {'Poggle The Lesser',60,4}
    
    if Settings['videos'] then
        gStateMachine:change('GameState',{'Sand Dunes', 'video', 2, 0, 0, 0, 'Clone Wars Theme.oga'})
    else
        gStateMachine:change('GameState',{'Sand Dunes', 'photo', 0, 0, 0, 0, 'Clone Wars Theme.oga'})
    end
end

function sithTriumvirate()
    P2_deck_cards[0] = {'Sith Marauder',60,4}
    P2_deck_cards[1] = {'Sith Assassin',60,4}
    P2_deck_cards[2] = {'Darth Traya',60,4}
    P2_deck_cards[3] = {'Darth Nihilus',60,4}
    P2_deck_cards[4] = {'Darth Sion',60,4}
    P2_deck_cards[5] = {'HK-50',60,4}
    P2_deck_cards[6] = {'Meetra Surik',60,4}
    P2_deck_cards[7] = {'The Disciple',60,4}
    P2_deck_cards[8] = {'Visas Marr',60,4}
    P2_deck_cards[9] = {'Atton Rand',60,4}
    P2_deck_cards[10] = {'Mandalore The Preserver',60,4}
    P2_deck_cards[11] = {'T3-M4',60,4}
    P2_deck_cards[12] = {'G0-T0',60,4}
    P2_deck_cards[13] = {'The Handmaiden',60,4}
    P2_deck_cards[14] = {'Bao-Dur',60,4}
    P2_deck_cards[15] = {'HK-47',60,4}
    P2_deck_cards[16] = {'Mira',60,4}
    P2_deck_cards[17] = {'Hanharr',60,4}

    gStateMachine:change('GameState',{'Sith Triumvirate', 'photo', 0, 1, 1 ,1, 'The Old Republic.oga'})
end

function maxedDarkSide()
    P2_deck_cards[0] = {'Darth Marr',60,4}
    P2_deck_cards[1] = {'Grand Inquisitor',60,4}
    P2_deck_cards[2] = {'Darth Vader',60,4}
    P2_deck_cards[3] = {'Darth Sion',60,4}
    P2_deck_cards[4] = {'Ninth Sister',60,4}
    P2_deck_cards[5] = {'Count Dooku',60,4}
    P2_deck_cards[6] = {'Seventh Sister',60,4}
    P2_deck_cards[7] = {'Darth Malgus',60,4}
    P2_deck_cards[8] = {'Darth Revan',60,4}
    P2_deck_cards[9] = {'Emperor Palpatine',60,4}
    P2_deck_cards[10] = {'Supreme Leader Snoke',60,4}
    P2_deck_cards[11] = {'Darth Bane',60,4}
    P2_deck_cards[12] = {'Fifth Brother',60,4}
    P2_deck_cards[13] = {'Darth Nihilus',60,4}
    P2_deck_cards[14] = {'The Son',60,4}
    P2_deck_cards[15] = {'Sith Eternal Emperor',60,4}
    P2_deck_cards[16] = {'Trilla Suduri',60,4}
    P2_deck_cards[17] = {'Eighth Brother',60,4}

    if Settings['videos'] then
        gStateMachine:change('GameState',{'Sand Dunes', 'video', 2, 0, 0, 0, 'Binary Sunset.oga'})
    else
        gStateMachine:change('GameState',{'Sand Dunes', 'photo', 0, 0, 0, 0, 'Binary Sunset.oga'})
    end
end

function maxedLightSide()
    P2_deck_cards[0] = {'Ahsoka Tano Fulcrum',60,4}
    P2_deck_cards[1] = {'Hermit Luke Skywalker',60,4}
    P2_deck_cards[2] = {'Jedi Knight Revan',60,4}
    P2_deck_cards[3] = {'Yoda',60,4}
    P2_deck_cards[4] = {'Ahsoka Tano Mandalorian',60,4}
    P2_deck_cards[5] = {'Ahsoka Tano S7',60,4}
    P2_deck_cards[6] = {'Jedi Knight Luke Skywalker',60,4}
    P2_deck_cards[7] = {'Meetra Surik',60,4}
    P2_deck_cards[8] = {'Mace Windu',60,4}
    P2_deck_cards[9] = {'Jedi Knight Anakin Skywalker',60,4}
    P2_deck_cards[10] = {'Hermit Yoda',60,4}
    P2_deck_cards[11] = {'Jedi Master Obi-Wan Kenobi',60,4}
    P2_deck_cards[12] = {'Visas Marr',60,4}
    P2_deck_cards[13] = {'Kit Fisto',60,4}
    P2_deck_cards[14] = {'The Daughter',60,4}
    P2_deck_cards[15] = {'Kreia',60,4}
    P2_deck_cards[16] = {'Quinlan Vos',60,4}
    P2_deck_cards[17] = {'Atris',60,4}
    
    gStateMachine:change('GameState',{'Voss', 'photo', 0, 1, 1, 1, 'The Mandalorian.oga'})
end

function maxed()
    P2_deck_cards[0] = {'Darth Vader',60,4}
    P2_deck_cards[1] = {'Yoda',60,4}
    P2_deck_cards[2] = {'Jedi Knight Revan',60,4}
    P2_deck_cards[3] = {'Zillo Beast',60,4}
    P2_deck_cards[4] = {'Mace Windu',60,4}
    P2_deck_cards[5] = {'Ahsoka Tano Mandalorian',60,4}
    P2_deck_cards[6] = {'Jedi Knight Anakin Skywalker',60,4}
    P2_deck_cards[7] = {'Emperor Palpatine',60,4}
    P2_deck_cards[8] = {'The Father',60,4}
    P2_deck_cards[9] = {'Darth Revan',60,4}
    P2_deck_cards[10] = {'Hermit Luke Skywalker',60,4}
    P2_deck_cards[11] = {'Meetra Surik',60,4}
    P2_deck_cards[12] = {'Darth Nihilus',60,4}
    P2_deck_cards[13] = {'The Daughter',60,4}
    P2_deck_cards[14] = {'The Son',60,4}
    P2_deck_cards[15] = {'Force Priestess',60,4}
    P2_deck_cards[16] = {'Sith Eternal Emperor',60,4}
    P2_deck_cards[17] = {'Bendu',60,4}

    gStateMachine:change('GameState',{'Belsavis', 'photo', 0, 0, 0 ,0, 'Throne Room.oga'})
end