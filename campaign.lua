function endor()
    P2_deck_cards[0] = {'Tokkat',60,4}
    P2_deck_cards[1] = {'Paploo',60,4}
    P2_deck_cards[2] = {'Wicket W Warrick',60,4}
    P2_deck_cards[3] = {'Teebo',60,4}
    P2_deck_cards[4] = {'Chief Chirpa',60,4}
    P2_deck_cards[5] = {'Logray',60,4}

    gStateMachine:change('GameState',{'Endor.jpg', 'photo', 0, 1, 1 ,1, 'Imperial March Duet.mp3'})
end

function kamino()
    P2_deck_cards[0] = {'Captain Vaughn',60,4}
    P2_deck_cards[1] = {'Commander Gree',60,4}
    P2_deck_cards[2] = {'Commander Bacara',60,4}
    P2_deck_cards[3] = {'Commander Bly',60,4}
    P2_deck_cards[4] = {'ARC Trooper',60,4}
    P2_deck_cards[5] = {'Clone Commando',60,4}
    P2_deck_cards[6] = {'ARC Trooper Echo',60,4}
    P2_deck_cards[7] = {'ARC Trooper Fives',60,4}
    P2_deck_cards[8] = {'ARC Trooper Jesse',60,4}
    P2_deck_cards[9] = {'Commander Cody',60,4}
    P2_deck_cards[10] = {'Captain Rex',60,4}
    P2_deck_cards[11] = {'322nd Clone Trooper',60,4}
    P2_deck_cards[12] = {'327th Clone Trooper',60,4}
    P2_deck_cards[13] = {'501st Clone Trooper',60,4}
    P2_deck_cards[14] = {'212th Clone Trooper',60,4}
    P2_deck_cards[15] = {'Commander Wolffe',60,4}
    P2_deck_cards[16] = {'Coruscant Guard Clone Trooper',60,4}
    P2_deck_cards[17] = {'Clone Commando Gregor',60,4}

    gStateMachine:change('GameState',{'Kamino.jpg', 'photo', 0, 1, 1 ,1, 'Clone  Wars Theme.oga'})
end

function throne_room()
    P2_deck_cards[1] = {'Royal Guard',60,4}
    P2_deck_cards[2] = {'Emperor Palpatine',60,4}
    P2_deck_cards[3] = {'Darth Vader',60,4}
    P2_deck_cards[4] = {'Royal Guard',60,4}
   
    gStateMachine:change('GameState',{'Death Star Control Room.jpg', 'photo', 0, 1, 1 ,1, 'Imperial March Piano Only.oga'})
end

function maxed_dark_side()
    P2_deck_cards[0] = {'Kylo Ren',60,4}
    P2_deck_cards[1] = {'Supreme Leader Snoke',60,4}
    P2_deck_cards[2] = {'Emperor Palpatine',60,4}
    P2_deck_cards[3] = {'Darth Vader',60,4}
    P2_deck_cards[4] = {'Count Dooku',60,4}
    P2_deck_cards[5] = {'Ninth Sister',60,4}
    P2_deck_cards[6] = {'General Grievous',60,4}
    P2_deck_cards[7] = {'Maul',60,4}
    P2_deck_cards[8] = {'Pong Krell',60,4}
    P2_deck_cards[9] = {'Savage Opress',60,4}
    P2_deck_cards[10] = {'Asajj Ventress',60,4}
    P2_deck_cards[11] = {'Eighth Brother',60,4}
    P2_deck_cards[12] = {'Pre Vizsla',60,4}
    P2_deck_cards[13] = {'Trilla Suduri',60,4}
    P2_deck_cards[14] = {'Sith Eternal Emperor',60,4}
    P2_deck_cards[15] = {'Fifth Brother',60,4}
    P2_deck_cards[16] = {'Grand Inquisitor',60,4}
    P2_deck_cards[17] = {'Seventh Sister',60,4}

    if Settings['videos'] then
        gStateMachine:change('GameState',{'Sand Dunes.ogv', 'video', 2, 0, 0, 0, 'Binary Sunset.oga'})
    else
        gStateMachine:change('GameState',{'Sand Dunes.jpg', 'photo', 0, 0, 0, 0, 'Binary Sunset.oga'})
    end
end

function maxed_light_side()
    P2_deck_cards[0] = {'Ahsoka Tano Fulcrum',60,4}
    P2_deck_cards[1] = {'Yoda',60,4}
    P2_deck_cards[2] = {'Hermit Luke Skywalker',60,4}
    P2_deck_cards[3] = {'Mace Windu',60,4}
    P2_deck_cards[4] = {'Jedi Master Obi-Wan Kenobi',60,4}
    P2_deck_cards[5] = {'Jedi Knight Luke Skywalker',60,4}
    P2_deck_cards[6] = {'Aayla Secura',60,4}
    P2_deck_cards[7] = {'Agen Kolar',60,4}
    P2_deck_cards[8] = {'Jedi Knight Anakin Skywalker',60,4}
    P2_deck_cards[9] = {'Ahsoka Tano S7',60,4}
    P2_deck_cards[10] = {'Saesee Tiin',60,4}
    P2_deck_cards[11] = {'Quinlan Vos',60,4}
    P2_deck_cards[12] = {'Din Djarin',60,4}
    P2_deck_cards[13] = {'Boba Fett Mandalorian',60,4}
    P2_deck_cards[14] = {'Bendu',60,4}
    P2_deck_cards[15] = {'Hermit Yoda',60,4}
    P2_deck_cards[16] = {' Nightsister Merrin',60,4}
    P2_deck_cards[17] = {'Bo-Katan Kryze',60,4}
    
    gStateMachine:change('GameState',{'Voss.jpg', 'photo', 0, 1, 1, 1, 'The Mandalorian.oga'})
end

function maxed()
    P2_deck_cards[0] = {'Mace Windu',60,4}
    P2_deck_cards[1] = {'Emperor Palpatine',60,4}
    P2_deck_cards[2] = {'Zillo Beast',60,4}
    P2_deck_cards[3] = {'Hermit Luke Skywalker',60,4}
    P2_deck_cards[4] = {'Darth Vader',60,4}
    P2_deck_cards[5] = {'Yoda',60,4}
    P2_deck_cards[6] = {'Ahsoka Tano Fulcrum',60,4}
    P2_deck_cards[7] = {'Jedi Knight Anakin Skywalker',60,4}
    P2_deck_cards[8] = {'Supreme Leader Snoke',60,4}
    P2_deck_cards[9] = {'Count Dooku',60,4}
    P2_deck_cards[10] = {'Pong Krell',60,4}
    P2_deck_cards[11] = {'Jedi Knight Luke Skywalker',60,4}
    P2_deck_cards[12] = {'Grand Inquisitor',60,4}
    P2_deck_cards[13] = {'Hermit Yoda',60,4}
    P2_deck_cards[14] = {'Sith Eternal Emperor',60,4}
    P2_deck_cards[15] = {'Bendu',60,4}
    P2_deck_cards[16] = {'Ninth Sister',60,4}
    P2_deck_cards[17] = {'Trilla Suduri',60,4}

    gStateMachine:change('GameState',{'Belsavis.jpg', 'photo', 0, 0, 0 ,0, 'Throne Room.oga'})
end