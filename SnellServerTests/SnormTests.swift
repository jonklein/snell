//
//  SwtlTemplateSpec.swift
//  Snell
//
//  Created by Jonathan Klein on 6/20/15.
//  Copyright © 2015 artificial. All rights reserved.
//

import Quick
import Nimble

class SnormSpec: QuickSpec {
  class Fruit : SnormModel {
    var name:String

    init(name:String) {
      self.name = name
    }

    override var description: String { return self.name }
  }


  override func spec() {
    describe("Snorm.") {
      beforeEach {
        SnormAdapter.sharedAdapter().reset()
      }

      it("should return objects") {
        expect(Fruit.all().array.endIndex).to(equal(0))
      }

      it("should insert objects") {
        let banana = Fruit(name: "Banana")
        banana.save()
        expect(Fruit.all().array.endIndex).to(equal(1))
      }

      it("should delete objects") {
        let banana = Fruit(name: "Banana")
        banana.save()
        expect(Fruit.all().array.endIndex).to(equal(1))
        banana.destroy()
        expect(Fruit.all().array.endIndex).to(equal(0))
      }

      it("should have nil ID before save") {
        let banana = Fruit(name: "Banana")
        expect(banana.id).to(beNil())
      }

      it("should not be saved after save") {
        let banana = Fruit(name: "Banana")
        expect(banana.saved()).to(equal(false))
      }

      it("should have non-nil ID after save") {
        let banana = Fruit(name: "Banana")
        banana.save()
        expect(banana.id).toNot(beNil())
      }

      it("should be saved after save") {
        let banana = Fruit(name: "Banana")
        banana.save()
        expect(banana.saved()).to(equal(true))
      }

      it("should return all objects") {
        let apple = Fruit(name: "Apple")
        let banana = Fruit(name: "Banana")

        apple.save()
        banana.save()

        expect(Set(Fruit.all().array)).to(equal([apple, banana]))
      }

      it("should scope objects") {
        let apple  = Fruit(name: "Apple")
        let banana = Fruit(name: "Banana")
        let cherry = Fruit(name: "Cherry")

        apple.save()
        banana.save()
        cherry.save()

        expect(Set(Fruit.with("name like '*e*'").array)).to(equal([apple, cherry]))
      }

      it("should chain object scopes") {
        let apple  = Fruit(name: "Apple")
        let banana = Fruit(name: "Banana")
        let cherry = Fruit(name: "Cherry")

        apple.save()
        banana.save()
        cherry.save()

        expect(Set(Fruit.with("name like '*e*'").with("name like '*y*'").array)).to(equal([cherry]))
      }

      it("should scope with arguments") {
        let apple  = Fruit(name: "Apple")
        let banana = Fruit(name: "Banana")
        let cherry = Fruit(name: "Cherry")

        apple.save()
        banana.save()
        cherry.save()

        expect(Set(Fruit.with("name like %@", "*ppl*").array)).to(equal([apple]))
      }
    }
  }
}
