## Resources
- https://plantuml.com/
- use cases examples: https://real-world-plantuml.com/

## Example for shop factory and shop interact with shop and owners
```
@startuml
left to right direction
actor platform as p
package ShopOwners {
  actor owner1 as o1
  actor owner2 as o2
}

actor user as u

package ShopFactory {
  usecase "CreateShop" as CS
}

package Shop {
  usecase "PurchaseDesign" as PD
}

ShopOwners -up-> CS : One shop created\n for shop owners

CS -up-> Shop 
u -down-> PD : User purchase the design\n from this shop
PD -up-> p : Plaform charges\n management fee\n from each design purchase
PD -down-> ShopOwners: Shop owners get revenue\n from each shop purchase\n (after management fee)

@enduml
```