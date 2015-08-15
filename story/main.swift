
var prince, dragon: Actor;
var princess, cave, castle: Item;
var locations: [Item];
var alive: Attribute;
var location: Attribute


// <subject> go to <object1>
let goPossibles: PossibleActions = { sitch, verb, subject in
    return locations.map( { Action(verb:verb, subject:subject, object1:sitch.get($0)) } );
}

let goDoIt: DoIt = { sitch, action in
    action.subject.set(location, value: action.object1!)
}

// <subject> take <object1>
let takePossibles: PossibleActions = { sitch, verb, subject in
    let here = subject.get(location)
    return locations.map( { location in Action(verb:verb, subject:subject, object1:sitch.get( location )) } );
}

//// <subject> take <object1> from <object2>
let takeDoIt: DoIt = { sitch, action in
    action.object1!.set(location, value: action.object2!)
}

let fightDoIt: DoIt = {
    let sitch = $0;
    let action = $1;
    action.object1!.set(alive, value: False);
}

cave = Item(name: "Cave");
castle = Item(name: "Castle");
princess = Item(name: "princess");

alive = Attribute(name: "alive", possibleValues: [True, False])
location = Attribute(name: "location", possibleValues: [cave, castle])

let go    = Verb(name: "go",    possibles: goPossibles,     doIt: goDoIt);
let take  = Verb(name: "take",  possibles: takePossibles,   doIt: takeDoIt);
let fight = Verb(name: "fight", possibles: fightPossibles,  doIt: fightDoIt);

//let princessInCave   = Desire(item: cave,   inventory:[princess]);
//let princessInCastle = Desire(item: castle, inventory:[princess]);

//prince = Actor(name: "Prince", attributes: [alive], abilities: [go, take, fight], desires: [princessInCastle]);
//dragon = Actor(name: "Prince", attributes: [alive], abilities: [go, take, fight], desires: [princessInCave]);

Story.tell();


