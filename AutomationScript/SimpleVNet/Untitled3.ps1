{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "networkInterfaces_NetworkInterface_name": {
            "defaultValue": "NetworkInterface",
            "type": "String"
        },
        "publicIPAddresses_PublicIp_name": {
            "defaultValue": "PublicIp",
            "type": "String"
        },
        "virtualNetworks_VNet3_name": {
            "defaultValue": "VNet3",
            "type": "String"
        }
    },
    "variables": {},
    "resources": [
        {
            "comments": "Generalized from resource: '/subscriptions/7261fdd2-889c-491b-8657-1ff32e1cac4b/resourceGroups/cmTemplate3/providers/Microsoft.Network/networkInterfaces/NetworkInterface'.",
            "type": "Microsoft.Network/networkInterfaces",
            "name": "[parameters('networkInterfaces_NetworkInterface_name')]",
            "apiVersion": "2016-03-30",
            "location": "westus2",
            "properties": {
                "ipConfigurations": [
                    {
                        "name": "ipconfig1",
                        "properties": {
                            "privateIPAddress": "10.1.0.4",
                            "privateIPAllocationMethod": "Dynamic",
                            "subnet": {
                                "id": "[concat(resourceId('Microsoft.Network/virtualNetworks', parameters('virtualNetworks_VNet3_name')), '/subnets/Subnet_Name')]"
                            }
                        }
                    }
                ],
                "dnsSettings": {
                    "dnsServers": []
                },
                "enableIPForwarding": false
            },
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualNetworks', parameters('virtualNetworks_VNet3_name'))]"
            ]
        },
        {
            "comments": "Generalized from resource: '/subscriptions/7261fdd2-889c-491b-8657-1ff32e1cac4b/resourceGroups/cmTemplate3/providers/Microsoft.Network/publicIPAddresses/PublicIp'.",
            "type": "Microsoft.Network/publicIPAddresses",
            "name": "[parameters('publicIPAddresses_PublicIp_name')]",
            "apiVersion": "2016-03-30",
            "location": "westus2",
            "properties": {
                "publicIPAllocationMethod": "Dynamic",
                "idleTimeoutInMinutes": 4,
                "dnsSettings": {
                    "domainNameLabel": "pipdnsname4"
                }
            },
            "dependsOn": []
        },
        {
            "comments": "Generalized from resource: '/subscriptions/7261fdd2-889c-491b-8657-1ff32e1cac4b/resourceGroups/cmTemplate3/providers/Microsoft.Network/virtualNetworks/VNet3'.",
            "type": "Microsoft.Network/virtualNetworks",
            "name": "[parameters('virtualNetworks_VNet3_name')]",
            "apiVersion": "2016-03-30",
            "location": "westus2",
            "properties": {
                "addressSpace": {
                    "addressPrefixes": [
                        "10.1.0.0/24"
                    ]
                },
                "subnets": [
                    {
                        "name": "Subnet_Name",
                        "properties": {
                            "addressPrefix": "10.1.0.0/24"
                        }
                    }
                ]
            },
            "dependsOn": []
        }
    ]
}