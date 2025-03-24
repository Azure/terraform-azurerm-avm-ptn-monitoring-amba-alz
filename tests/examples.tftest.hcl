provider "azurerm" {
  features {}
}

variables {
  parent_resource_id         = "test"
  management_subscription_id = "test"
  location                   = "test"
}

run "examples_default" {
  command = plan

  module {
    source = "./examples/default"
  }
}

//run "examples_complete" {
//  command = plan
//
//  module {
//    source = "./examples/complete"
//  }
//}

//run "examples_custom_architecture_definition" {
//  command = plan
//
//  module {
//    source = "./examples/custom-architecture-definition"
//  }
//}
