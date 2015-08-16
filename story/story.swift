import Foundation

let True = NSNumber(bool: true);
let False = NSNumber(bool: false);

typealias PossibleActions = (sitch: Sitch, verb:Verb, subject: Item) -> [Action];
typealias DoIt = (sitch: Sitch, action: Action) -> ();

extension RangeReplaceableCollectionType where Generator.Element : Equatable {    
    // Remove first collection element that is equal to the given object:
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
    func contains(subset : [Generator.Element]) -> (Bool) {
        return subset.filter({ self.contains($0) }).count > 0;
    }
}

extension Array {
//    func toDict<K,V>(map: (Element) -> (key: K, value: V)?) -> [K: V] {
//        var dict = [K: V]()
//        for element in self {
//            if let (key, value) = map(element) {
//                dict[key] = value
//            }
//        }
//        return dict
//    }
    func rand() -> Element {
        let n = Int(arc4random_uniform(UInt32(self.count)))
        return self[n]
    }
}

class Item : NSObject {
    static var all = [Item]();
    var name: String;
    var attributes: [Attribute];
    
    init(name: String, attributes: [Attribute] = [Attribute]()) {
        self.name = name;
        self.attributes = attributes;
        super.init();
        Item.all.append(self);
    }
    func rand() -> Instance {
        
        var values = [Attribute:NSObject]()
        for attribute in self.attributes {
            values[attribute] = attribute.possibleValues.rand()
        }
        return Instance(model:self, values:values)
    }
}

class Attribute : NSObject {
    var name: String;
    var possibleValues: [NSObject];
    init(name: String, possibleValues: [NSObject]) {
        self.name = name;
        self.possibleValues = possibleValues;
    }
}

class Desire {
    var item: Item
    var attribute: Attribute
    var value: NSObject?

    init(item: Item, attribute: Attribute, value: NSObject) {
        self.item = item
        self.attribute = attribute
        self.value = value
    }

    func satisfied(sitch:Sitch) -> Bool {
        let instance = sitch.get(self.item);
        return instance.get(self.attribute) == self.value!;
    }
}

class Actor: Item {
    var desires: [Desire];
    var abilities: [Verb];

    init(name:String, attributes:[Attribute], abilities:[Verb], desires:[Desire]) {
        self.abilities = abilities;
        self.desires = desires;
        super.init(name:name, attributes:attributes);
    }

    func score(sitch:Sitch) -> Int {
        let d = self.desires.map( { $0.satisfied(sitch) ? 1 : 0 } );
        return d.reduce(0, combine: +);
    }
}

class Instance : NSObject {
    var model: Item;
    var values: [Attribute: NSObject];

    init(model: Item, values: [Attribute: NSObject]) {
        self.model = model;
        self.values = values;
    }
    
    func get(attribute:Attribute) -> NSObject? {
        return self.values[attribute];
    }
    
    func set(attribute:Attribute, value:NSObject) {
        self.values[attribute] = value;
    }
}

class Verb {
    var name: String;
    var possibles: PossibleActions;
    var doIt: DoIt;
    init(name: String, possibles: PossibleActions, doIt: DoIt) {
        self.name = name;
        self.possibles = possibles;
        self.doIt = doIt;
    }
}

class Action : NSObject {
    var verb: Verb;
    var subject: Item;
    var object1, object2: Item?;
    var value: NSObject?;
    init(verb:Verb, subject: Item, object1: Item? = nil, object2:Item? = nil, value:NSObject? = nil) {
        self.verb = verb;
        self.subject = subject;
        self.object1 = object1;
        self.object2 = object2;
        self.value = value;
    }
}

class Sitch: NSObject {
    var instances = [Item:Instance]()

    init (instances:[Instance]) {
        for instance in instances {
            self.instances[instance.model] = instance
        }
    }
    func get(item:Item) -> Instance {
        return self.instances[item]!
    }
    var score: Int {
        let actors = instances.values.filter({ $0.model is Actor })
        let scores = actors.map({ ($0.model as! Actor).score(self) })
        return scores.reduce(0, combine:+)
    }
    func tell() -> String {
        return Array(self.instances.values).description
    }
    override var description: String {
        return String(self.instances.values)
    }

    static func rand() -> Sitch {
        let instances = Item.all.map({ item in item.rand() })
        return Sitch(instances:instances)
    }
    
    func copyWithZone(zone: NSZone) -> AnyObject! {
        return Sitch(instances: Array(self.instances.values))
    }
}

class Story {
    var arc = [Sitch]();

    init(sitch:Sitch) {
        self.arc.append(sitch)
    }
    
    var score: Int {
        return arc.reduce(0, combine: { $0 + $1.score });
    }
    
    func plot(count:Int) {
        let sitch = self.arc.last
        for _ in 0..<count {
            let sitch = sitch!.copy() as! Sitch
            let actor = Item.all.filter( { item in item is Actor } ).rand() as! Actor
            let verb = actor.abilities.rand()
            let action = verb.possibles(sitch: sitch, verb:verb, subject:actor).rand()
            verb.doIt(sitch: sitch, action:action)
            self.arc.append(sitch)
        }
    }
    
    static func compose(count:Int) -> Story {
        var stories = [Story]()
        let sitches = (1..<count).map( { n in Sitch.rand() }) // pick some random starting points
        for sitch in sitches {
            let story = Story(sitch:sitch)
            story.plot(count) // pick random events to make story
        }
        return stories[1..<stories.count].reduce(stories[0], combine:{ $0.score > $1.score ? $0 : $1 })
    }

    func tell() {
        var t = self.arc.reduce("Once upon a time...\n", combine:{ $0 + $1.description } );
        t += "...and they lived happily ever after.";
        print(t);
    }
}
