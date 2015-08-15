import Foundation

let True = NSNumber(bool: true);
let False = NSNumber(bool: false);

typealias PossibleActions = (sitch: Sitch, verb:Verb, subject: Instance) -> [Action];
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

class Item : NSObject {
    static var all = [Item]();
    var name: String;
    var attributes: [Attribute]?;
    init(name: String, attributes: [Attribute]? = nil) {
        self.name = name;
        self.attributes = attributes;
        super.init();
        Item.all.append(self);
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
//    var inventory: [Item]?;

    init(item: Item, attribute: Attribute, value: NSObject) {
        self.item = item
        self.attribute = attribute
        self.value = value
//        self.inventory = nil;
    }
    
//    init(item: Item, inventory: [Item]) {
//        self.item = item
//        self.inventory = inventory;
//        self.attribute = nil;
//        self.value = nil;
//    }
    
    func satisfied(sitch:Sitch) -> Bool {
        let instance = sitch.get(self.item);
//        if (self.attribute != nil) {
            return instance.get(self.attribute) == self.value!;
//        }
        
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
//    var inventory = [Item](); // things I have
//    var within: Instance?; // the thing that has me (location, vessel, etc.)

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
    
//    func transfer(to:Instance) {
//        if (within != nil) {
//            within!.inventory.removeObject(self.model);
//        }
//        to.inventory.append(self.model);
//        self.within = to;
//    }

}

//let nearby: PossibleActions = {
//    let sitch = $0;
//    let verb = $1;
//    let subject = $2;
//    let iaf = Item.all.filter({ subject.within == sitch.get($0).within });
//    return iaf.map( { Action(verb: verb, subject: subject, object1: sitch.get($0)) } );
//}

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
    var subject: Instance;
    var object1, object2: Instance?;
    var value: NSObject?;
    init(verb:Verb, subject: Instance, object1: Instance? = nil, object2:Instance? = nil, value:NSObject? = nil) {
        self.verb = verb;
        self.subject = subject;
        self.object1 = object1;
        self.object2 = object2;
        self.value = value;
    }
}

class Sitch: CustomStringConvertible {
    var instances = [Item:Instance]();
    var consequences = [Action:Sitch]();
    func add(instance:Instance) {
        self.instances[instance.model] = instance;
    }
    func get(item:Item) -> Instance {
        return self.instances[item]!;
    }
    var score: Int {
        let actors = instances.values.filter({ $0.model is Actor });
        let scores = actors.map({ ($0.model as! Actor).score(self) });
        return scores.reduce(0, combine:+);
    }
    func tell() -> String {
        return Array(self.instances.values).description;
    }
    var description: String {
        return String(self.instances.values);
    }
}

class Story {
    var arc = [Sitch]();

    func add(sitch: Sitch) {
        self.arc.append(sitch);
    }
    var score: Int {
        return arc.reduce(0, combine: { $0 + $1.score });
    }

    static func tell() {
        let s = Story();
        var t = s.arc.reduce("Once upon a time...\n", combine:{ $0 + $1.description } );
        t += "...and they lived happily ever after.";
        print(t);
    }
}
