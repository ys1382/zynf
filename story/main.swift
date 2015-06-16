
var prince, dragon: Actor;
var princess, cave, castle: Item;

cave = Item(name: "Cave");
castle = Item(name: "Castle");
princess = Item(name: "princess");

let alive = Attribute(name: "alive", possibleValues: [True, False]);
let locations = [cave, castle];

//typealias Possibles = (sitch: Sitch, verb:Verb, subject: Instance) -> [Action];
//typealias DoIt = (sitch: Sitch, action: Action) -> (Sitch);

// <subject goto <object1>
let goPossibles: Possibles = {
    let sitch = $0;
    let verb = $1;
    let subject = $2;
    return locations.map( { Action(verb:verb, subject:subject, object1:sitch.get($0)) } );
}

let goDoIt: DoIt = {
    let sitch = $0;
    let action = $1;
    action.subject.transfer(action.object1!);
}

// <subject> take <object1> from <object2>
let takeDoIt: DoIt = {
    let sitch = $0;
    let action = $1;
    action.object1!.transfer(action.object2!);
}

let fightDoIt: DoIt = {
    let sitch = $0;
    let action = $1;
    action.object1!.set(alive, value: False);
}

let go    = Verb(name: "go",    possibles: goPossibles, doIt: goDoIt);
let take  = Verb(name: "take",  possibles: nearby,      doIt: takeDoIt);
let fight = Verb(name: "fight", possibles: nearby,      doIt: fightDoIt);

let princessInCave   = Desire(item: cave,   inventory:[princess]);
let princessInCastle = Desire(item: castle, inventory:[princess]);

prince = Actor(name: "Prince", attributes: [alive], abilities: [go, take, fight], desires: [princessInCastle]);
dragon = Actor(name: "Prince", attributes: [alive], abilities: [go, take, fight], desires: [princessInCave]);


