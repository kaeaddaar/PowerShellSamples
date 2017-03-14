{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "virtualMachines_AD_adminPassword": {
            "defaultValue": null,
            "type": "SecureString"
        },
        "virtualMachines_cmRDSH_adminPassword": {
            "defaultValue": null,
            "type": "SecureString"
        },
        "virtualMachines_AD_name": {
            "defaultValue": "AD",
            "type": "String"
        },
        "virtualMachines_cmRDSH_name": {
            "defaultValue": "cmRDSH",
            "type": "String"
        },
        "loadBalancers_cmPsLoadBalancer_name": {
            "defaultValue": "cmPsLoadBalancer",
            "type": "String"
        },
        "networkInterfaces_ad809_name": {
            "defaultValue": "ad809",
            "type": "String"
        },
        "networkInterfaces_cmpsbackendnic1_name": {
            "defaultValue": "cmpsbackendnic1",
            "type": "String"
        },
        "networkInterfaces_cmpsbackendnic2_name": {
            "defaultValue": "cmpsbackendnic2",
            "type": "String"
        },
        "networkInterfaces_cmPSNIC_name": {
            "defaultValue": "cmPSNIC",
            "type": "String"
        },
        "publicIPAddresses_AD_ip_name": {
            "defaultValue": "AD-ip",
            "type": "String"
        },
        "publicIPAddresses_cmPsPublicIp_name": {
            "defaultValue": "cmPsPublicIp",
            "type": "String"
        },
        "virtualNetworks_cmPSVnet_name": {
            "defaultValue": "cmPSVnet",
            "type": "String"
        },
        "storageAccounts_cmpsstorageacct_name": {
            "defaultValue": "cmpsstorageacct",
            "type": "String"
        },
        "loadBalancers_cmPsLoadBalancer_id": {
            "defaultValue": "/subscriptions/7261fdd2-889c-491b-8657-1ff32e1cac4b/resourceGroups/cmRDSH2/providers/Microsoft.Network/loadBalancers/cmPsLoadBalancer/frontendIPConfigurations/cmPsFrontEndIp",
            "type": "String"
        }
    },
    "variables": {},
    "resources": [
        {
            "comments": "Generalized from resource: '/subscriptions/7261fdd2-889c-491b-8657-1ff32e1cac4b/resourceGroups/cmRDSH2/providers/Microsoft.Compute/virtualMachines/AD'.",
            "type": "Microsoft.Compute/virtualMachines",
            "name": "[parameters('virtualMachines_AD_name')]",
            "apiVersion": "2015-06-15",
            "location": "westus2",
            "properties": {
                "hardwareProfile": {
                    "vmSize": "Standard_D1_v2"
                },
                "storageProfile": {
                    "imageReference": {
                        "publisher": "MicrosoftWindowsServer",
                        "offer": "WindowsServer",
                        "sku": "2016-Datacenter",
                        "version": "latest"
                    },
                    "osDisk": {
                        "name": "[parameters('virtualMachines_AD_name')]",
                        "createOption": "FromImage",
                        "vhd": {
                            "uri": "[concat('https://cmdevrgdisks601.blob.core.windows.net/vhds/', parameters('virtualMachines_AD_name'),'20170226231303.vhd')]"
                        },
                        "caching": "[concat('ReadWrite')]"
                    },
                    "dataDisks": []
                },
                "osProfile": {
                    "computerName": "[parameters('virtualMachines_AD_name')]",
                    "adminUsername": "cmackay",
                    "windowsConfiguration": {
                        "provisionVMAgent": true,
                        "enableAutomaticUpdates": true
                    },
                    "secrets": [],
                    "adminPassword": "[parameters('virtualMachines_AD_adminPassword')]"
                },
                "networkProfile": {
                    "networkInterfaces": [
                        {
                            "id": "[resourceId('Microsoft.Network/networkInterfaces', parameters('networkInterfaces_ad809_name'))]"
                        }
                    ]
                }
            },
            "dependsOn": [
                "[resourceId('Microsoft.Network/networkInterfaces', parameters('networkInterfaces_ad809_name'))]"
            ]
        },
        {
            "comments": "Generalized from resource: '/subscriptions/7261fdd2-889c-491b-8657-1ff32e1cac4b/resourceGroups/cmRDSH2/providers/Microsoft.Compute/virtualMachines/cmRDSH'.",
            "type": "Microsoft.Compute/virtualMachines",
            "name": "[parameters('virtualMachines_cmRDSH_name')]",
            "apiVersion": "2015-06-15",
            "location": "westus2",
            "properties": {
                "hardwareProfile": {
                    "vmSize": "Standard_A1"
                },
                "storageProfile": {
                    "imageReference": {
                        "publisher": "MicrosoftWindowsServer",
                        "offer": "WindowsServer",
                        "sku": "2016-Datacenter",
                        "version": "latest"
                    },
                    "osDisk": {
                        "name": "myOsDisk1",
                        "createOption": "FromImage",
                        "vhd": {
                            "uri": "[concat('https', '://', parameters('storageAccounts_cmpsstorageacct_name'), '.blob.core.windows.net', '/vhds/myOsDisk1.vhd')]"
                        },
                        "caching": "ReadWrite"
                    },
                    "dataDisks": []
                },
                "osProfile": {
                    "computerName": "[parameters('virtualMachines_cmRDSH_name')]",
                    "adminUsername": "cmackay",
                    "windowsConfiguration": {
                        "provisionVMAgent": true,
                        "enableAutomaticUpdates": true
                    },
                    "secrets": [],
                    "adminPassword": "[parameters('virtualMachines_cmRDSH_adminPassword')]"
                },
                "networkProfile": {
                    "networkInterfaces": [
                        {
                            "id": "[resourceId('Microsoft.Network/networkInterfaces', parameters('networkInterfaces_cmpsbackendnic2_name'))]"
                        }
                    ]
                }
            },
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_cmpsstorageacct_name'))]",
                "[resourceId('Microsoft.Network/networkInterfaces', parameters('networkInterfaces_cmpsbackendnic2_name'))]"
            ]
        },
        {
            "comments": "Generalized from resource: '/subscriptions/7261fdd2-889c-491b-8657-1ff32e1cac4b/resourceGroups/cmRDSH2/providers/Microsoft.Network/loadBalancers/cmPsLoadBalancer'.",
            "type": "Microsoft.Network/loadBalancers",
            "name": "[parameters('loadBalancers_cmPsLoadBalancer_name')]",
            "apiVersion": "2016-03-30",
            "location": "westus2",
            "properties": {
                "frontendIPConfigurations": [
                    {
                        "name": "cmPsFrontEndIp",
                        "properties": {
                            "privateIPAddress": "10.0.0.5",
                            "privateIPAllocationMethod": "Static",
                            "subnet": {
                                "id": "[concat(resourceId('Microsoft.Network/virtualNetworks', parameters('virtualNetworks_cmPSVnet_name')), '/subnets/cmPSSubnet')]"
                            }
                        }
                    }
                ],
                "backendAddressPools": [
                    {
                        "name": "cmPsBackEndIp"
                    }
                ],
                "loadBalancingRules": [],
                "probes": [
                    {
                        "name": "cmPsHealthProbe",
                        "properties": {
                            "protocol": "Http",
                            "port": 80,
                            "requestPath": "./",
                            "intervalInSeconds": 15,
                            "numberOfProbes": 2
                        }
                    }
                ],
                "inboundNatRules": [
                    {
                        "name": "cmPsInboundNatRdp1",
                        "properties": {
                            "frontendIPConfiguration": {
                                "id": "[parameters('loadBalancers_cmPsLoadBalancer_id')]"
                            },
                            "frontendPort": 3441,
                            "backendPort": 3389,
                            "protocol": "Tcp"
                        }
                    }
                ],
                "outboundNatRules": [],
                "inboundNatPools": []
            },
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualNetworks', parameters('virtualNetworks_cmPSVnet_name'))]"
            ]
        },
        {
            "comments": "Generalized from resource: '/subscriptions/7261fdd2-889c-491b-8657-1ff32e1cac4b/resourceGroups/cmRDSH2/providers/Microsoft.Network/networkInterfaces/ad809'.",
            "type": "Microsoft.Network/networkInterfaces",
            "name": "[parameters('networkInterfaces_ad809_name')]",
            "apiVersion": "2016-03-30",
            "location": "westus2",
            "properties": {
                "ipConfigurations": [
                    {
                        "name": "ipconfig1",
                        "properties": {
                            "privateIPAddress": "10.0.0.8",
                            "privateIPAllocationMethod": "Dynamic",
                            "publicIPAddress": {
                                "id": "[resourceId('Microsoft.Network/publicIPAddresses', parameters('publicIPAddresses_AD_ip_name'))]"
                            },
                            "subnet": {
                                "id": "[concat(resourceId('Microsoft.Network/virtualNetworks', parameters('virtualNetworks_cmPSVnet_name')), '/subnets/cmPSSubnet')]"
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
                "[resourceId('Microsoft.Network/publicIPAddresses', parameters('publicIPAddresses_AD_ip_name'))]",
                "[resourceId('Microsoft.Network/virtualNetworks', parameters('virtualNetworks_cmPSVnet_name'))]"
            ]
        },
        {
            "comments": "Generalized from resource: '/subscriptions/7261fdd2-889c-491b-8657-1ff32e1cac4b/resourceGroups/cmRDSH2/providers/Microsoft.Network/networkInterfaces/cmpsbackendnic1'.",
            "type": "Microsoft.Network/networkInterfaces",
            "name": "[parameters('networkInterfaces_cmpsbackendnic1_name')]",
            "apiVersion": "2016-03-30",
            "location": "westus2",
            "properties": {
                "ipConfigurations": [
                    {
                        "name": "ipconfig1",
                        "properties": {
                            "privateIPAddress": "10.0.0.6",
                            "privateIPAllocationMethod": "Static",
                            "subnet": {
                                "id": "[concat(resourceId('Microsoft.Network/virtualNetworks', parameters('virtualNetworks_cmPSVnet_name')), '/subnets/cmPSSubnet')]"
                            },
                            "loadBalancerBackendAddressPools": [
                                {
                                    "id": "[concat(resourceId('Microsoft.Network/loadBalancers', parameters('loadBalancers_cmPsLoadBalancer_name')), '/backendAddressPools/cmPsBackEndIp')]"
                                }
                            ],
                            "loadBalancerInboundNatRules": [
                                {
                                    "id": "[concat(resourceId('Microsoft.Network/loadBalancers', parameters('loadBalancers_cmPsLoadBalancer_name')), '/inboundNatRules/cmPsInboundNatRdp1')]"
                                }
                            ]
                        }
                    }
                ],
                "dnsSettings": {
                    "dnsServers": []
                },
                "enableIPForwarding": false
            },
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualNetworks', parameters('virtualNetworks_cmPSVnet_name'))]",
                "[resourceId('Microsoft.Network/loadBalancers', parameters('loadBalancers_cmPsLoadBalancer_name'))]"
            ]
        },
        {
            "comments": "Generalized from resource: '/subscriptions/7261fdd2-889c-491b-8657-1ff32e1cac4b/resourceGroups/cmRDSH2/providers/Microsoft.Network/networkInterfaces/cmpsbackendnic2'.",
            "type": "Microsoft.Network/networkInterfaces",
            "name": "[parameters('networkInterfaces_cmpsbackendnic2_name')]",
            "apiVersion": "2016-03-30",
            "location": "westus2",
            "properties": {
                "ipConfigurations": [
                    {
                        "name": "ipconfig1",
                        "properties": {
                            "privateIPAddress": "10.0.0.7",
                            "privateIPAllocationMethod": "Static",
                            "subnet": {
                                "id": "[concat(resourceId('Microsoft.Network/virtualNetworks', parameters('virtualNetworks_cmPSVnet_name')), '/subnets/cmPSSubnet')]"
                            },
                            "loadBalancerBackendAddressPools": [
                                {
                                    "id": "[concat(resourceId('Microsoft.Network/loadBalancers', parameters('loadBalancers_cmPsLoadBalancer_name')), '/backendAddressPools/cmPsBackEndIp')]"
                                }
                            ]
                        }
                    }
                ],
                "dnsSettings": {
                    "dnsServers": []
                },
                "enableIPForwarding": false
            },
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualNetworks', parameters('virtualNetworks_cmPSVnet_name'))]",
                "[resourceId('Microsoft.Network/loadBalancers', parameters('loadBalancers_cmPsLoadBalancer_name'))]"
            ]
        },
        {
            "comments": "Generalized from resource: '/subscriptions/7261fdd2-889c-491b-8657-1ff32e1cac4b/resourceGroups/cmRDSH2/providers/Microsoft.Network/networkInterfaces/cmPSNIC'.",
            "type": "Microsoft.Network/networkInterfaces",
            "name": "[parameters('networkInterfaces_cmPSNIC_name')]",
            "apiVersion": "2016-03-30",
            "location": "westus2",
            "properties": {
                "ipConfigurations": [
                    {
                        "name": "ipconfig1",
                        "properties": {
                            "privateIPAddress": "10.0.0.4",
                            "privateIPAllocationMethod": "Dynamic",
                            "publicIPAddress": {
                                "id": "[resourceId('Microsoft.Network/publicIPAddresses', parameters('publicIPAddresses_cmPsPublicIp_name'))]"
                            },
                            "subnet": {
                                "id": "[concat(resourceId('Microsoft.Network/virtualNetworks', parameters('virtualNetworks_cmPSVnet_name')), '/subnets/cmPSSubnet')]"
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
                "[resourceId('Microsoft.Network/publicIPAddresses', parameters('publicIPAddresses_cmPsPublicIp_name'))]",
                "[resourceId('Microsoft.Network/virtualNetworks', parameters('virtualNetworks_cmPSVnet_name'))]"
            ]
        },
        {
            "comments": "Generalized from resource: '/subscriptions/7261fdd2-889c-491b-8657-1ff32e1cac4b/resourceGroups/cmRDSH2/providers/Microsoft.Network/publicIPAddresses/AD-ip'.",
            "type": "Microsoft.Network/publicIPAddresses",
            "name": "[parameters('publicIPAddresses_AD_ip_name')]",
            "apiVersion": "2016-03-30",
            "location": "westus2",
            "properties": {
                "publicIPAllocationMethod": "Dynamic",
                "idleTimeoutInMinutes": 4
            },
            "dependsOn": []
        },
        {
            "comments": "Generalized from resource: '/subscriptions/7261fdd2-889c-491b-8657-1ff32e1cac4b/resourceGroups/cmRDSH2/providers/Microsoft.Network/publicIPAddresses/cmPsPublicIp'.",
            "type": "Microsoft.Network/publicIPAddresses",
            "name": "[parameters('publicIPAddresses_cmPsPublicIp_name')]",
            "apiVersion": "2016-03-30",
            "location": "westus2",
            "properties": {
                "publicIPAllocationMethod": "Dynamic",
                "idleTimeoutInMinutes": 4
            },
            "dependsOn": []
        },
        {
            "comments": "Generalized from resource: '/subscriptions/7261fdd2-889c-491b-8657-1ff32e1cac4b/resourceGroups/cmRDSH2/providers/Microsoft.Network/virtualNetworks/cmPSVnet'.",
            "type": "Microsoft.Network/virtualNetworks",
            "name": "[parameters('virtualNetworks_cmPSVnet_name')]",
            "apiVersion": "2016-03-30",
            "location": "westus2",
            "properties": {
                "addressSpace": {
                    "addressPrefixes": [
                        "10.0.0.0/16"
                    ]
                },
                "subnets": [
                    {
                        "name": "cmPSSubnet",
                        "properties": {
                            "addressPrefix": "10.0.0.0/24"
                        }
                    }
                ]
            },
            "dependsOn": []
        },
        {
            "comments": "Generalized from resource: '/subscriptions/7261fdd2-889c-491b-8657-1ff32e1cac4b/resourceGroups/cmrdsh2/providers/Microsoft.Storage/storageAccounts/cmpsstorageacct'.",
            "type": "Microsoft.Storage/storageAccounts",
            "sku": {
                "name": "Standard_LRS",
                "tier": "Standard"
            },
            "kind": "Storage",
            "name": "[parameters('storageAccounts_cmpsstorageacct_name')]",
            "apiVersion": "2016-01-01",
            "location": "westus2",
            "tags": {},
            "properties": {},
            "dependsOn": []
        }
    ]
}