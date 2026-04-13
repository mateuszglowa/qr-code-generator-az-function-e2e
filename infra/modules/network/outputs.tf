output "vnet_id" {
    value = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
    value = azurerm_virtual_network.vnet.name
}

output "subnets" {
    value = {
        for k, v in azurerm_subnet.subnet : k => {
            id = v.id
            name = v.name
        }
    }
}