output "policy_definition_id" {
  value = data.azurerm_policy_definition.inherit_tag.id
}

output "storage_account_names" {
  value = [
    azurerm_storage_account.sa_team_a.name,
    azurerm_storage_account.sa_team_b.name,
  ]
}
