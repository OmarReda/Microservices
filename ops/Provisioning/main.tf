# Define Resource Group
resource "azurerm_resource_group" "aks_rg" {
  name     = "aks-resource-group"
  location = "East US"

  tags = {
    environment = "Development"
    project     = "Python Microservice"
    owner       = "Team Name"
  }
}

# Define Azure Kubernetes Service (AKS) Cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "my-aks-cluster"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "myaksdns"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "Development"
    project     = "Python Microservice"
    owner       = "Team Name"
  }
}

# Create Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = "myacrregistry"
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = azurerm_resource_group.aks_rg.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = {
    environment = "Development"
    project     = "Python Microservice"
    owner       = "Team Name"
  }
}

# Output for Kubernetes Configuration
output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  sensitive = true
}

# Output for ACR Login Server
output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}