
var prince, dragon: Actor
var princess, cave, castle: Item
var locations: [Item]
var alive: Attribute
var location: Attribute
//var contains: Attribute

// <subject> go to <object1>
let goPossibles: PossibleActions = { sitch, verb, subject in
    let here = sitch.get(subject).values[location]
    let elsewhere = locations.filter( { there in here != there } )
    let exits = elsewhere.map( { location in Action(verb:verb, subject:subject, object1:location) } )
    return exits
}

let goDoIt: DoIt = { sitch, action in
    let subjectInstance = sitch.get(action.subject)
    subjectInstance.set(location, value: action.object1!)
}

func actionify(instances:[Instance], verb:Verb, subject:Item) -> [Action] {
    return instances.map( { neighbor in Action(verb:verb, subject:subject, object1:neighbor.model) })
}

//// <subject> take <object1> from <object2>
let takeDoIt: DoIt = { sitch, action in
    let object1Instance = sitch.get(action.object1!)
    object1Instance.set(location, value: action.subject)
}

let killDoIt: DoIt = { sitch, action in
    let object1Instance = sitch.get(action.object1!)
    object1Instance.set(alive, value: False)
}

cave =   Item(name: "the Dragon's cave")
castle = Item(name: "the Prince's castle")
locations = [castle, cave]

alive =     Attribute(name: "alive", possibleValues: [True, False])
location = Attribute(name: "location", possibleValues: [cave, castle])

func nearby(sitch: Sitch, verb: Verb, subject: Item) -> [Instance] {
    
    let si = sitch.get(subject)
    let here = si.get(location) as! Item
    return Array(sitch.instances.values).filter( { i in si != i && i.get(location) == here } )
}

let nearbyActions: PossibleActions = { sitch, verb, subject in
    let neighbors = nearby(sitch, verb: verb, subject: subject)
    return actionify(neighbors, verb:verb, subject:subject)
}

let nearbyAlive : PossibleActions = { sitch, verb, subject in
    let n = nearby(sitch, verb: verb, subject: subject)
    let na = n.filter({ i in i.get(alive) == True })
    return actionify(na, verb:verb, subject:subject)
}

princess = Item(name: "the Princess", attributes:[alive, location]);

let go   = Verb(name: "went to",    possibles: goPossibles, doIt: goDoIt);
let take = Verb(name: "took",       possibles: nearbyActions,      doIt: takeDoIt);
let kill = Verb(name: "killed",     possibles: nearbyAlive, doIt: killDoIt);

let princessInCave   = Desire(item: princess, attribute:location, value:cave)
let princessInCastle = Desire(item: princess, attribute:location, value:castle)

prince = Actor(name: "the Prince", attributes: [alive, location], abilities: [go, take, kill], desires: [princessInCastle]);
dragon = Actor(name: "the Dragon", attributes: [alive, location], abilities: [go, take, kill], desires: [princessInCave]);

Story.compose(3).tell();

