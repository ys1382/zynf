
var prince, dragon: Actor;
var princess, cave, castle: Item;
var locations: [Item];
var alive: Attribute;
var location: Attribute
var contains: Attribute

// <subject> go to <object1>
let goPossibles: PossibleActions = { sitch, verb, subject in
    return locations.map( { location in Action(verb:verb, subject:subject, object1:location) } )
}

let goDoIt: DoIt = { sitch, action in
    let subjectInstance = sitch.get(action.subject)
    subjectInstance.set(location, value: action.object1!)
}

let nearby: PossibleActions = { sitch, verb, subject in
    
    let subjectInstance = sitch.get(subject)
    let here = subjectInstance.get(location) as! Item
    let here2 = sitch.get(here)
    let neighbors = here2.get(contains) as! [Item]

    return neighbors.map( { neighbor in Action(verb:verb, subject:subject, object1:neighbor) });
}

//// <subject> take <object1> from <object2>
let takeDoIt: DoIt = { sitch, action in
    let object1Instance = sitch.get(action.object1!)
        object1Instance.set(location, value: action.object2!)
}

let fightDoIt: DoIt = { sitch, action in
    let object1Instance = sitch.get(action.object1!)
    object1Instance.set(alive, value: False);
}

cave = Item(name: "Cave");
castle = Item(name: "Castle");

alive = Attribute(name: "alive", possibleValues: [True, False])
location = Attribute(name: "location", possibleValues: [cave, castle])

princess = Item(name: "princess", attributes:[alive, location]);

let go    = Verb(name: "go",    possibles: goPossibles, doIt: goDoIt);
let take  = Verb(name: "take",  possibles: nearby,      doIt: takeDoIt);
let fight = Verb(name: "fight", possibles: nearby,      doIt: fightDoIt);

let princessInCave   = Desire(item: princess, attribute:location, value:cave)
let princessInCastle = Desire(item: princess, attribute:location, value:castle)

prince = Actor(name: "Prince", attributes: [alive, location], abilities: [go, take, fight], desires: [princessInCastle]);
dragon = Actor(name: "Prince", attributes: [alive, location], abilities: [go, take, fight], desires: [princessInCave]);

Story.compose(2).tell();

