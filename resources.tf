resource "azurerm_resource_group" "rg_team_a" {
  name     = "rg-team-a"
  location = var.location
  tags     = merge(local.common_tags, local.teams.teamA, local.workloads.dev01)
}

resource "azurerm_storage_account" "sa_team_a" {
  name                     = "stteamatest"
  resource_group_name      = azurerm_resource_group.rg_team_a.name
  location                 = azurerm_resource_group.rg_team_a.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = azurerm_resource_group.rg_team_a.tags
}

resource "azurerm_resource_group" "rg_team_b" {
  name     = "rg-team-b"
  location = var.location
  tags     = merge(local.common_tags, local.teams.teamB, local.workloads.dev02)
}

resource "azurerm_storage_account" "sa_team_b" {
  name                     = "stteambtest"
  resource_group_name      = azurerm_resource_group.rg_team_b.name
  location                 = azurerm_resource_group.rg_team_b.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = azurerm_resource_group.rg_team_b.tags
}