data "azurerm_policy_definition" "inherit_tag" {
  display_name = "Inherit a tag from the resource group if missing"
}

resource "azurerm_resource_group_policy_assignment" "inherit_tag" {
  for_each = local.inherited_tags

  name                 = "inherit-${each.key}"
  resource_group_id    = azurerm_resource_group.rg_team_a.id
  policy_definition_id = data.azurerm_policy_definition.inherit_tag.id
  location             = var.location

  parameters = jsonencode({
    tagName = { value = each.key }
  })

  # Modify efekat menja resurse, pa assignmentu treba identitet
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "inherit_tag" {
  for_each = azurerm_resource_group_policy_assignment.inherit_tag

  scope                = azurerm_resource_group.rg_team_a.id
  role_definition_name = "Tag Contributor"
  principal_id         = each.value.identity[0].principal_id
}

resource "azurerm_resource_group_policy_remediation" "inherit_tag" {
  for_each = azurerm_resource_group_policy_assignment.inherit_tag

  name                 = "remediate-inherit-${each.key}"
  resource_group_id    = azurerm_resource_group.rg_team_a.id
  policy_assignment_id = each.value.id
  location_filters     = [var.location]

  depends_on = [azurerm_role_assignment.inherit_tag]
}
